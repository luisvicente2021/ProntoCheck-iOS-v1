//
//  AttendanceRepository.swift
//  ProntoCheck
//
//  Created by luisr on 04/07/26.
//

import Foundation

final class AttendanceRepository: AttendanceRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func registerAttendance(
        empleadoId: UUID,
        tipo: AttendanceType,
        idPuntoAcceso: UUID
    ) async throws -> Attendance {
        
        let request = RegisterAttendanceRequest(
            employeeId: empleadoId,
            accessPointId: idPuntoAcceso,
            type: tipo
        )
        
      /*  let request = RegisterAttendanceRequest(
            empleadoId: empleadoId,
            tipo: tipo,
            idPuntoAcceso: idPuntoAcceso,
            fechaHora: ISO8601DateFormatter().string(from: Date())
        )*/

        let response: [Attendance] = try await networkService.request(
            endpoint: AttendanceEndpoint.register(request)
        )

        guard let attendance = response.first else {
            throw NSError(
                domain: "AttendanceRepository",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "No se pudo registrar la asistencia"
                ]
            )
        }

        return attendance
    }
}
