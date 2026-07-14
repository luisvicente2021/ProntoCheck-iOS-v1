//
//  FaceCaptureView.swift
//  ProntoCheck
//
//  Created by usuario on 14/07/26.
//

import Foundation
import SwiftUI
import UIKit

struct FaceCaptureView: View {

    let onImageCaptured: (UIImage) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            CameraView { image in
                onImageCaptured(image)
                dismiss()
            }
            .ignoresSafeArea()
            .navigationTitle("Capturar rostro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
