//
//  EmployeeFaceEnrollmentView.swift
//  ProntoCheck
//
//  Created by usuario on 14/07/26.
//

import Foundation
import SwiftUI

struct EmployeeFaceEnrollmentView: View {

    @StateObject private var viewModel: EmployeeFaceEnrollmentViewModel
    @State private var isCameraPresented = false

    init(viewModel: EmployeeFaceEnrollmentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView("Cargando empleados...")
            }

            ForEach(viewModel.employees) { employee in
                employeeRow(employee)
            }
        }
        .navigationTitle("Registrar rostro")
        .task {
            await viewModel.loadEmployees()
        }
        .sheet(isPresented: $isCameraPresented) {
            FaceCaptureView { image in
                Task {
                    await viewModel.enrollFace(from: image)
                }
            }
        }
        .overlay {
            if viewModel.isSaving {
                ZStack {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()

                    ProgressView("Guardando rostro...")
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.thinMaterial)
            }
        }
    }

    private func employeeRow(
        _ employee: Employee
    ) -> some View {
        Button {
            viewModel.selectEmployee(employee)
            isCameraPresented = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(employee.fullName)
                        .font(.headline)

                    Text(
                        employee.faceEmbeddingIOS == nil
                        ? "Sin rostro registrado"
                        : "Rostro registrado"
                    )
                    .font(.caption)
                    .foregroundStyle(
                        employee.faceEmbeddingIOS == nil
                        ? Color.orange
                        : Color.green
                    )
                }

                Spacer()

                Image(systemName: "camera.fill")
                    .foregroundStyle(.blue)
            }
        }
        .buttonStyle(.plain)
    }
}
