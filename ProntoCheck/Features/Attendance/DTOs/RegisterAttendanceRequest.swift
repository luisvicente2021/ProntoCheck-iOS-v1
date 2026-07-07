//
//  RegisterAttendanceRequest.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//
import Foundation

struct RegisterAttendanceRequest: Codable {
    let employeeId: UUID
    let type: AttendanceType
    let accessPointId: UUID
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case employeeId = "empleado_id"
        case type = "tipo"
        case accessPointId = "id_punto_acceso"
        case dateTime = "fecha_hora"
    }
}
