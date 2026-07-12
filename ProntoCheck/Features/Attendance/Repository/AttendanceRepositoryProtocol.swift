//
//  AttendanceRepositoryProtocol.swift
//  ProntoCheck
//
//  Created by usuario on 07/07/26.
//

import Foundation

protocol AttendanceRepositoryProtocol {
    func registerAttendance(
        employeeId: UUID,
        type: AttendanceType,
        accessPointId: UUID,
        dateTime: String
    ) async throws -> Attendance
}
