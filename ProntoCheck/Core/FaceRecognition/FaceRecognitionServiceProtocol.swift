//
//  FaceRecognitionServiceProtocol.swift
//  ProntoCheck
//
//  Created by usuario on 13/07/26.
//

import Foundation
import UIKit

protocol FaceRecognitionServiceProtocol {
    func extractFace(from image: UIImage) async throws -> UIImage

    func generateEmbedding(from image: UIImage) async throws -> [Float]

    func findMatchingEmployee(
        embedding: [Float],
        employees: [Employee]
    ) -> FaceMatchResult?
}
