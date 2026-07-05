//
//  RegisterAttendanceRequest.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//
import Foundation

struct RegisterAttendanceRequest: Encodable {

    let employeeId: UUID
    let accessPointId: UUID
    let type: AttendanceType

    enum CodingKeys: String, CodingKey {
        case employeeId = "empleado_id"
        case accessPointId = "id_punto_acceso"
        case type = "tipo"
    }
}
