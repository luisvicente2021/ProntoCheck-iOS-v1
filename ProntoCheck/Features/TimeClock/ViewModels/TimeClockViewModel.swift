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
        print("✅ TimeClockViewModel: iniciando validación")

        scannerStatus = "ESCANEANDO..."
        statusMessage = "Analizando rostro..."
        isFaceValidated = false
        detectedEmployee = nil

        do {
            let embedding = try await faceRecognitionService
                .generateEmbedding(from: image)

            print("✅ Embedding generated:", embedding.count)

            guard let match = faceRecognitionService.findMatchingEmployee(
                embedding: embedding,
                employees: employees
            ) else {
                scannerStatus = "NO AUTORIZADO"
                statusMessage = "Rostro no reconocido"
                print("❌ No employee match found")
                return
            }

            detectedEmployee = match.employee
            isFaceValidated = true
            scannerStatus = "ROSTRO OK"
            statusMessage = "Bienvenido, \(match.employee.fullName)"

            print("✅ Employee matched:", match.employee.fullName)
            print("Distance:", match.distance)

        } catch {
            isFaceValidated = false
            detectedEmployee = nil
            scannerStatus = "ERROR"
            statusMessage = error.localizedDescription

            print("❌ Face validation error:", error)
        }
    }

    func stopClock() {
        clockTask?.cancel()
        clockTask = nil
    }

    private func loadEmployees() async {
        do {
            employees = try await employeeRepository.fetchEmployees()
            print("Employees loaded:", employees.count)

        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Missing key:", key.stringValue)
            print("Context:", context.debugDescription)
            print("Path:", context.codingPath.map(\.stringValue))
            statusMessage = "Falta un campo del empleado"

        } catch let DecodingError.valueNotFound(type, context) {
            print("❌ Unexpected null for:", type)
            print("Context:", context.debugDescription)
            print("Path:", context.codingPath.map(\.stringValue))
            statusMessage = "Un dato obligatorio del empleado está vacío"

        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type mismatch:", type)
            print("Context:", context.debugDescription)
            print("Path:", context.codingPath.map(\.stringValue))
            statusMessage = "Un dato del empleado tiene un formato incorrecto"

        } catch let DecodingError.dataCorrupted(context) {
            print("❌ Corrupted data:", context.debugDescription)
            print("Path:", context.codingPath.map(\.stringValue))
            statusMessage = "Los datos del empleado no son válidos"

        } catch {
            print("❌ Employee loading error:", error)
            statusMessage = "No se pudieron cargar los empleados"
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
