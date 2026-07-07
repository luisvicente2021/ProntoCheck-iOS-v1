//
//  AttendanceRepositoryProtocol.swift
//  ProntoCheck
//
//  Created by usuario on 07/07/26.
//

import Foundation

protocol AttendanceRepositoryProtocol {
    func registerAttendance(
        empleadoId: UUID,
        tipo: AttendanceType,
        idPuntoAcceso: UUID
    ) async throws -> Attendance
}
