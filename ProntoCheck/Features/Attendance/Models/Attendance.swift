//
//  Attendance.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//
import Foundation

struct Attendance: Identifiable, Codable {
    let id: UUID
    let empleadoId: UUID
    let tipo: AttendanceType
    let fecha: String?
    let hora: String?
    let createdAt: String?
    let idPuntoAcceso: UUID
    let fechaHora: String?

    enum CodingKeys: String, CodingKey {
        case id
        case empleadoId = "empleado_id"
        case tipo
        case fecha
        case hora
        case createdAt = "created_at"
        case idPuntoAcceso = "id_punto_acceso"
        case fechaHora = "fecha_hora"
    }
}
