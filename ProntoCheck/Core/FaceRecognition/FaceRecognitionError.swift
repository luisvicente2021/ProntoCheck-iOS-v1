//
//  FaceRecognitionError.swift
//  ProntoCheck
//
//  Created by usuario on 13/07/26.
//

import Foundation

enum FaceRecognitionError: LocalizedError {
    case invalidImage
    case faceNotDetected
    case multipleFacesDetected
    case unableToCropFace
    case invalidModelInput
    case invalidModelOutput
    case emptyEmbedding

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "La imagen capturada no es válida."

        case .faceNotDetected:
            return "No se detectó ningún rostro."

        case .multipleFacesDetected:
            return "Se detectó más de un rostro."

        case .unableToCropFace:
            return "No fue posible recortar el rostro."

        case .invalidModelInput:
            return "No fue posible preparar la imagen para el modelo."

        case .invalidModelOutput:
            return "El modelo no devolvió un resultado válido."

        case .emptyEmbedding:
            return "El modelo generó un embedding vacío."
        }
    }
}
