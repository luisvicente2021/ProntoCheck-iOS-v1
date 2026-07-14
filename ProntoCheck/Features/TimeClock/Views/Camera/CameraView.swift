import AVFoundation
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {

    let onImageCaptured: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onImageCaptured: onImageCaptured,
            dismiss: dismiss
        )
    }

    func makeUIViewController(
        context: Context
    ) -> CameraViewController {
        CameraViewController(coordinator: context.coordinator)
    }

    func updateUIViewController(
        _ uiViewController: CameraViewController,
        context: Context
    ) {
    }

    static func dismantleUIViewController(
        _ uiViewController: CameraViewController,
        coordinator: Coordinator
    ) {
        uiViewController.stopSession()
    }

    final class Coordinator:
        NSObject,
        AVCapturePhotoCaptureDelegate {

        private let onImageCaptured: (UIImage) -> Void
        private let dismiss: DismissAction

        init(
            onImageCaptured: @escaping (UIImage) -> Void,
            dismiss: DismissAction
        ) {
            self.onImageCaptured = onImageCaptured
            self.dismiss = dismiss
        }

        func photoOutput(
            _ output: AVCapturePhotoOutput,
            didFinishProcessingPhoto photo: AVCapturePhoto,
            error: Error?
        ) {
            if let error {
                print("❌ Camera capture error:", error)
                dismiss()
                return
            }

            guard
                let imageData = photo.fileDataRepresentation(),
                let image = UIImage(data: imageData)
            else {
                print("❌ No se pudo crear UIImage")
                dismiss()
                return
            }

            let normalizedImage = image.normalizedForFaceRecognition()

            print("✅ AVFoundation image captured")
            print("Image size:", normalizedImage.size)
            print("Orientation:", normalizedImage.imageOrientation.rawValue)

            onImageCaptured(normalizedImage)
            dismiss()
        }
    }
}

final class CameraViewController: UIViewController {

    private let coordinator: CameraView.Coordinator

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    private let sessionQueue = DispatchQueue(
        label: "com.prontocheck.camera.session"
    )

    private let previewView = UIView()
    private var previewLayer: AVCaptureVideoPreviewLayer?

    private var isSessionConfigured = false
    private var isCapturingPhoto = false

    init(coordinator: CameraView.Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        configurePreviewView()
        configureCaptureButton()
        requestCameraPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewView.frame = view.bounds
        previewLayer?.frame = previewView.bounds

        configurePreviewConnection()
    }

    private func configurePreviewView() {
        previewView.frame = view.bounds
        previewView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        previewView.backgroundColor = .black

        view.addSubview(previewView)
    }

    private func configureCaptureButton() {
        let captureButton = UIButton(type: .system)

        captureButton.setTitle(
            "Tomar foto",
            for: .normal
        )

        captureButton.setTitleColor(
            .black,
            for: .normal
        )

        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 28

        captureButton.titleLabel?.font = .systemFont(
            ofSize: 18,
            weight: .semibold
        )

        captureButton.addTarget(
            self,
            action: #selector(capturePhoto),
            for: .touchUpInside
        )

        captureButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(captureButton)

        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            ),
            captureButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            captureButton.widthAnchor.constraint(
                equalToConstant: 150
            ),
            captureButton.heightAnchor.constraint(
                equalToConstant: 56
            )
        ])
    }

    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSessionIfNeeded()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    print("❌ Camera permission denied")
                    return
                }

                self?.configureSessionIfNeeded()
            }

        case .denied, .restricted:
            print("❌ Camera permission unavailable")

        @unknown default:
            print("❌ Unknown camera authorization status")
        }
    }

    private func configureSessionIfNeeded() {
        sessionQueue.async { [weak self] in
            guard let self, !self.isSessionConfigured else {
                return
            }

            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            defer {
                self.session.commitConfiguration()
            }

            guard let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front
            ) else {
                print("❌ Front camera unavailable")
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: device)

                guard self.session.canAddInput(input) else {
                    print("❌ Cannot add camera input")
                    return
                }

                self.session.addInput(input)
            } catch {
                print("❌ Camera input error:", error)
                return
            }

            guard self.session.canAddOutput(self.photoOutput) else {
                print("❌ Cannot add photo output")
                return
            }

            self.session.addOutput(self.photoOutput)
            self.isSessionConfigured = true

            DispatchQueue.main.async { [weak self] in
                self?.configurePreviewLayer()
            }

            self.startSession()
        }
    }

    private func configurePreviewLayer() {
        guard previewLayer == nil else {
            return
        }

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = previewView.bounds

        previewView.layer.insertSublayer(layer, at: 0)
        previewLayer = layer

        configurePreviewConnection()
    }

    private func configurePreviewConnection() {
        guard let connection = previewLayer?.connection else {
            return
        }

        if connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }

        connection.automaticallyAdjustsVideoMirroring = false

        if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = true
        }
    }

    private func configurePhotoConnection() {
        guard let connection = photoOutput.connection(with: .video) else {
            return
        }

        if connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }

        connection.automaticallyAdjustsVideoMirroring = false

        if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = false
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            guard
                let self,
                self.isSessionConfigured,
                !self.session.isRunning
            else {
                return
            }

            self.session.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            guard
                let self,
                self.session.isRunning
            else {
                return
            }

            self.session.stopRunning()
        }
    }

    @objc
    private func capturePhoto() {
        guard !isCapturingPhoto else {
            return
        }

        isCapturingPhoto = true
        configurePhotoConnection()

        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off

        photoOutput.capturePhoto(
            with: settings,
            delegate: coordinator
        )

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1
        ) { [weak self] in
            self?.isCapturingPhoto = false
        }
    }
}
