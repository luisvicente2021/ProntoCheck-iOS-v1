//
//  Attendance.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//
import Foundation

struct Attendance: Identifiable {
    let id: UUID?
    let employeeId: UUID
    let accessPointId: UUID
    let type: AttendanceType
}
