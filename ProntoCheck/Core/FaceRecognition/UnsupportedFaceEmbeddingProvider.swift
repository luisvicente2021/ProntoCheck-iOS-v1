//
//  UnsupportedFaceEmbeddingProvider.swift
//  ProntoCheck
//
//  Created by usuario on 13/07/26.
//

import Foundation
import UIKit

final class UnsupportedFaceEmbeddingProvider: FaceEmbeddingProviderProtocol {

    func generateEmbedding(
        from faceImage: UIImage
    ) async throws -> [Float] {
        throw FaceRecognitionError.invalidModelOutput
    }
}
