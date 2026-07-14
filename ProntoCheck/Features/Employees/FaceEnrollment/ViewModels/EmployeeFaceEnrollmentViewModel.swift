//
//  EmployeeFaceEnrollmentViewModel.swift
//  ProntoCheck
//
//  Created by usuario on 14/07/26.
//
import Foundation
import UIKit

@MainActor
final class EmployeeFaceEnrollmentViewModel: ObservableObject {

    private let employeeRepository: EmployeeRepositoryProtocol
    private let faceRecognitionService: FaceRecognitionServiceProtocol

    @Published private(set) var employees: [Employee] = []
    @Published private(set) var selectedEmployee: Employee?

    @Published private(set) var isLoading = false
    @Published private(set) var isSaving = false
    @Published var statusMessage = ""

    init(
        employeeRepository: EmployeeRepositoryProtocol,
        faceRecognitionService: FaceRecognitionServiceProtocol
    ) {
        self.employeeRepository = employeeRepository
        self.faceRecognitionService = faceRecognitionService
    }

    func loadEmployees() async {
        isLoading = true
        defer { isLoading = false }

        do {
            employees = try await employeeRepository.fetchEmployees()
        } catch {
            statusMessage = "No se pudieron cargar los empleados"
            print("Employee loading error:", error)
        }
    }

    func selectEmployee(_ employee: Employee) {
        selectedEmployee = employee
        statusMessage = ""
    }

    func enrollFace(from image: UIImage) async {
        guard let selectedEmployee else {
            statusMessage = "Selecciona un empleado"
            return
        }

        isSaving = true
        defer { isSaving = false }

        do {
            let embedding = try await faceRecognitionService
                .generateEmbedding(from: image)

            guard embedding.count == 512 else {
                statusMessage = "El embedding generado no es válido"
                return
            }

            let updatedEmployee = try await employeeRepository
                .updateFaceEmbedding(
                    employeeId: selectedEmployee.id,
                    embedding: embedding
                )

            if let index = employees.firstIndex(
                where: { $0.id == updatedEmployee.id }
            ) {
                employees[index] = updatedEmployee
            }

            self.selectedEmployee = updatedEmployee
            statusMessage = "Rostro registrado correctamente"
        } catch {
            statusMessage = error.localizedDescription
            print("Face enrollment error:", error)
        }
    }
}
