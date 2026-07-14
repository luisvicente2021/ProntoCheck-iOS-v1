//
//  RelojViewModel.swift
//  ProntoCheck
//
//  Created by luisr on 12/07/26.
//

import Foundation
import UIKit

@MainActor
final class TimeClockViewModel: ObservableObject {

    private let employeeRepository: EmployeeRepositoryProtocol
    private let faceRecognitionService: FaceRecognitionServiceProtocol

    @Published private(set) var employees: [Employee] = []
    @Published private(set) var detectedEmployee: Employee?

    @Published var availableAttendanceType: AttendanceType = .entrada
    @Published var scannerStatus = "ESPERANDO"
    @Published var statusMessage = "Coloca tu rostro frente a la cámara"
    @Published var isFaceValidated = false
    @Published var isLocationValidated = false
    @Published var currentTime = ""
    @Published var currentDate = ""

    private var clockTask: Task<Void, Never>?

    init(
        employeeRepository: EmployeeRepositoryProtocol,
        faceRecognitionService: FaceRecognitionServiceProtocol
    ) {
        self.employeeRepository = employeeRepository
        self.faceRecognitionService = faceRecognitionService
    }

    func start() async {
        startClock()
        await loadEmployees()
    }

    func validateFace(_ image: UIImage) async {
        scannerStatus = "ESCANEANDO..."
        statusMessage = "Analizando rostro..."
        isFaceValidated = false
        detectedEmployee = nil

        do {
            let embedding = try await faceRecognitionService
                .generateEmbedding(from: image)

            guard let match = faceRecognitionService.findMatchingEmployee(
                embedding: embedding,
                employees: employees
            ) else {
                scannerStatus = "NO AUTORIZADO"
                statusMessage = "Rostro no reconocido"
                return
            }

            detectedEmployee = match.employee
            isFaceValidated = true
            scannerStatus = "ROSTRO OK"
            statusMessage = "Bienvenido, \(match.employee.fullName)"

            print(
                "Employee matched:",
                match.employee.fullName,
                "distance:",
                match.distance
            )
        } catch {
            isFaceValidated = false
            detectedEmployee = nil

            if let localizedError = error as? LocalizedError,
               let description = localizedError.errorDescription {
                statusMessage = description
            } else {
                statusMessage = "No fue posible validar el rostro"
            }

            scannerStatus = "ERROR"
            print("Face recognition error:", error)
        }
    }

    func stopClock() {
        clockTask?.cancel()
        clockTask = nil
    }

    private func loadEmployees() async {
        do {
            employees = try await employeeRepository.fetchEmployees()

            if employees.isEmpty {
                statusMessage = "No hay empleados disponibles"
            }
        } catch {
            statusMessage = "No se pudieron cargar los empleados"
            print("Employee loading error:", error)
        }
    }

    private func startClock() {
        clockTask?.cancel()

        clockTask = Task {
            while !Task.isCancelled {
                updateDateTime()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func updateDateTime() {
        let now = Date()

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "es_MX")
        timeFormatter.dateFormat = "hh:mm:ss a"

        currentTime = timeFormatter.string(from: now)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "EEEE d 'de' MMMM yyyy"

        currentDate = dateFormatter
            .string(from: now)
            .capitalized
    }
}
