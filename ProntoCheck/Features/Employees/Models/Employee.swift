//
//  Employee.swift
//  ProntoCheck
//
//  Created by luisr on 12/07/26.
//

import Foundation

struct Employee: Codable, Identifiable {

    let id: UUID
    let email: String?
    let firstName: String
    let position: String?

    let paternalLastName: String?
    let maternalLastName: String?

    let residentialArea: String?
    let address: String?

    let homePhone: String?
    let companyPhone: String?

    let latitude: Double?
    let longitude: Double?

    let faceEmbedding: String?
    let faceEmbeddingIOS: [Float]?
    let faceEmbeddingAndroid: String?

    let employeeCode: String

    let isActive: Bool?
    let workingHours: Int?

    let createdAt: String?

    var fullName: String {
        [
            firstName,
            paternalLastName,
            maternalLastName
        ]
        .compactMap { value in
            guard let value,
                  !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else {
                return nil
            }

            return value
        }
        .joined(separator: " ")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "nombre"
        case position = "puesto"

        case paternalLastName = "apellido_paterno"
        case maternalLastName = "apellido_materno"

        case residentialArea = "residencial"
        case address = "direccion"

        case homePhone = "telefono_casa"
        case companyPhone = "telefono_empresa"

        case latitude = "latitud"
        case longitude = "longitud"

        case faceEmbedding = "face_embedding"
        case faceEmbeddingIOS = "face_embedding_ios"
        case faceEmbeddingAndroid = "face_embedding_android"

        case employeeCode = "codigo_empleado"
        case isActive = "activo"
        case workingHours = "jornada_horas"
        case createdAt = "created_at"
    }
}
