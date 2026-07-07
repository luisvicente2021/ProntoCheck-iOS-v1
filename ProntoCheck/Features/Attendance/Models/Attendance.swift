//
//  Attendance.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//
import Foundation

struct Attendance: Identifiable, Codable {
    let id: UUID
    let employeeId: UUID
    let type: AttendanceType
    let date: String?
    let time: String?
    let createdAt: String?
    let accessPointId: UUID
    let dateTime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case employeeId = "empleado_id"
        case type = "tipo"
        case date = "fecha"
        case time = "hora"
        case createdAt = "created_at"
        case accessPointId = "id_punto_acceso"
        case dateTime = "fecha_hora"
    }
}
