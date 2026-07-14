//
//  FaceEmbeddingProviderProtocol.swift
//  ProntoCheck
//
//  Created by usuario on 13/07/26.
//

import Foundation
import UIKit

protocol FaceEmbeddingProviderProtocol {
    func generateEmbedding(from faceImage: UIImage) async throws -> [Float]
}
