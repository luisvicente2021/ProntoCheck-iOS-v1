//
//  FaceRecognitionService.swift
//  ProntoCheck
//
//  Created by usuario on 13/07/26.
//

import Foundation
import UIKit
import Vision
import CoreImage

final class FaceRecognitionService: FaceRecognitionServiceProtocol {

    private let embeddingProvider: FaceEmbeddingProviderProtocol
    private let recognitionThreshold: Float

    init(
        embeddingProvider: FaceEmbeddingProviderProtocol,
        recognitionThreshold: Float
    ) {
        self.embeddingProvider = embeddingProvider
        self.recognitionThreshold = recognitionThreshold
    }

    func extractFace(from image: UIImage) async throws -> UIImage {
        guard let cgImage = image.cgImage else {
            throw FaceRecognitionError.invalidImage
        }

        let orientation = CGImagePropertyOrientation(image.imageOrientation)

        let observations = try await detectFaces(
            in: cgImage,
            orientation: orientation
        )

        guard !observations.isEmpty else {
            throw FaceRecognitionError.faceNotDetected
        }

        guard observations.count == 1 else {
            throw FaceRecognitionError.multipleFacesDetected
        }

        guard let faceImage = cropFace(
            from: cgImage,
            observation: observations[0]
        ) else {
            throw FaceRecognitionError.unableToCropFace
        }

        return faceImage
    }

    func generateEmbedding(from image: UIImage) async throws -> [Float] {
        let faceImage = try await extractFace(from: image)

        let embedding = try await embeddingProvider.generateEmbedding(
            from: faceImage
        )

        guard !embedding.isEmpty else {
            throw FaceRecognitionError.emptyEmbedding
        }

        return normalize(embedding)
    }

    func findMatchingEmployee(
        embedding: [Float],
        employees: [Employee]
    ) -> FaceMatchResult? {
        let normalizedEmbedding = normalize(embedding)

        var bestEmployee: Employee?
        var bestDistance = Float.greatestFiniteMagnitude

        for employee in employees {
            guard let storedEmbedding = employee.faceEmbeddingIOS else {
                print("⚠️ No iOS embedding for:", employee.fullName)
                continue
            }

            print(
                "Employee:",
                employee.fullName,
                "stored:",
                storedEmbedding.count,
                "new:",
                normalizedEmbedding.count
            )

            guard storedEmbedding.count == normalizedEmbedding.count else {
                print("⚠️ Embedding dimension mismatch")
                continue
            }

            let normalizedStoredEmbedding = normalize(storedEmbedding)

            let distance = euclideanDistance(
                normalizedEmbedding,
                normalizedStoredEmbedding
            )

            print("Distance for \(employee.fullName):", distance)

            if distance < bestDistance {
                bestDistance = distance
                bestEmployee = employee
            }
        }

        guard let bestEmployee,
              bestDistance <= recognitionThreshold
        else {
            return nil
        }

        return FaceMatchResult(
            employee: bestEmployee,
            distance: bestDistance
        )
    }

    private func detectFaces(
        in cgImage: CGImage,
        orientation: CGImagePropertyOrientation
    ) async throws -> [VNFaceObservation] {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectFaceRectanglesRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = request.results as? [VNFaceObservation] ?? []
                continuation.resume(returning: observations)
            }

            let handler = VNImageRequestHandler(
                cgImage: cgImage,
                orientation: orientation,
                options: [:]
            )

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func cropFace(
        from cgImage: CGImage,
        observation: VNFaceObservation
    ) -> UIImage? {
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)

        let boundingBox = observation.boundingBox

        var cropRect = CGRect(
            x: boundingBox.origin.x * imageWidth,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageHeight,
            width: boundingBox.width * imageWidth,
            height: boundingBox.height * imageHeight
        )

        cropRect = expandedCropRect(
            cropRect,
            imageWidth: imageWidth,
            imageHeight: imageHeight
        )

        guard let croppedImage = cgImage.cropping(to: cropRect.integral) else {
            return nil
        }

        return UIImage(cgImage: croppedImage)
    }

    private func expandedCropRect(
        _ rect: CGRect,
        imageWidth: CGFloat,
        imageHeight: CGFloat
    ) -> CGRect {
        let horizontalPadding = rect.width * 0.20
        let verticalPadding = rect.height * 0.25

        let expandedRect = rect.insetBy(
            dx: -horizontalPadding,
            dy: -verticalPadding
        )

        let imageBounds = CGRect(
            x: 0,
            y: 0,
            width: imageWidth,
            height: imageHeight
        )

        return expandedRect.intersection(imageBounds)
    }

    private func euclideanDistance(
        _ first: [Float],
        _ second: [Float]
    ) -> Float {
        guard first.count == second.count else {
            return .greatestFiniteMagnitude
        }

        let squaredSum = zip(first, second).reduce(Float.zero) {
            partialResult,
            values in

            let difference = values.0 - values.1
            return partialResult + difference * difference
        }

        return sqrt(squaredSum)
    }

    private func normalize(_ values: [Float]) -> [Float] {
        let magnitude = sqrt(
            values.reduce(Float.zero) {
                $0 + ($1 * $1)
            }
        )

        guard magnitude > 0 else {
            return values
        }

        return values.map {
            $0 / magnitude
        }
    }
}
