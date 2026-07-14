//
//  UpdateFaceEmbeddingRequest.swift
//  ProntoCheck
//
//  Created by usuario on 14/07/26.
//

import Foundation

struct UpdateFaceEmbeddingRequest: Encodable {

    let faceEmbeddingIOS: [Float]

    enum CodingKeys: String, CodingKey {
        case faceEmbeddingIOS = "face_embedding_ios"
    }
}
