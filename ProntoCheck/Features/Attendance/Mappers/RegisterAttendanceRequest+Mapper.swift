//
//  ── RegisterAttendanceRequest+Mapper.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//
import Foundation

extension RegisterAttendanceRequest {

    func toDomain() -> Attendance {

        Attendance(
            id: nil,
            employeeId: employeeId,
            accessPointId: accessPointId,
            type: type
        )
    }
}
