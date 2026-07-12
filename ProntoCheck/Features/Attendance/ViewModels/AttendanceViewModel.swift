//
//  AttendanceViewModel.swift
//  ProntoCheck
//
//  Created by usuario on 07/07/26.
//

import Foundation

@MainActor
final class AttendanceViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var lastAttendance: Attendance?

    private let repository: AttendanceRepositoryProtocol

    init(repository: AttendanceRepositoryProtocol) {
        self.repository = repository
    }

    func registerAttendance(
        employeeId: UUID,
        type: AttendanceType,
        accessPointId: UUID,
        dateTime: String
    ) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let attendance = try await repository.registerAttendance(
                employeeId: employeeId,
                type: type,
                accessPointId: accessPointId,
                dateTime: dateTime
            )

            lastAttendance = attendance
            successMessage = type == .entrada
                ? "Entrada registrada correctamente"
                : "Salida registrada correctamente"

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
