//
//  TimeClockView.swift
//  ProntoCheck
//
//  Created by luisr on 12/07/26.
//

import SwiftUI

struct TimeClockView: View {
    
    @StateObject private var viewModel: TimeClockViewModel
    
    @State private var isCameraPresented = false
    @State private var isAdminLoginPresented = false
    
    init(viewModel: TimeClockViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    headerSection
                    cameraSection
                    statusSection
                    employeeSection
                    registerButton
                    messageSection
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("ProntoCheck")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            adminToolbarButton
        }
        .task {
            await viewModel.start()
        }
        .sheet(isPresented: $isCameraPresented) {
            FaceCaptureView { image in
                print("✅ TimeClockView: imagen recibida")

                Task {
                    await viewModel.validateFace(image)
                }
            }
        }
        .sheet(isPresented: $isAdminLoginPresented) {
            
        }
        .onDisappear {
            viewModel.stopClock()
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemGroupedBackground),
                Color.blue.opacity(0.08)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 4) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 55, height: 55)
            
            Text(viewModel.currentTime)
                .font(
                    .system(
                        size: 38,
                        weight: .bold,
                        design: .rounded
                    )
                )
            
            Text(viewModel.currentDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Camera
    
    private var cameraSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.black)
                .frame(height: 280)
            
            VStack(spacing: 14) {
                Image(systemName: "faceid")
                    .font(.system(size: 74))
                    .foregroundStyle(.white)
                
                Text(viewModel.scannerStatus)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(scannerStatusColor)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                
                Button {
                    isCameraPresented = true
                } label: {
                    Label(
                        "Escanear rostro",
                        systemImage: "camera.fill"
                    )
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                }
            }
        }
        .shadow(
            color: .black.opacity(0.12),
            radius: 8,
            y: 4
        )
    }
    
    // MARK: - Status
    
    private var statusSection: some View {
        HStack(spacing: 14) {
            StatusCard(
                title: "Rostro",
                value: viewModel.isFaceValidated
                ? "OK"
                : "Pendiente",
                systemImage: "faceid",
                isValid: viewModel.isFaceValidated
            )
            
            StatusCard(
                title: "Ubicación",
                value: viewModel.isLocationValidated
                ? "OK"
                : "Pendiente",
                systemImage: "location.fill",
                isValid: viewModel.isLocationValidated
            )
        }
    }
    
    // MARK: - Employee
    
    private var employeeSection: some View {
        VStack(spacing: 10) {
            Text("Empleado detectado")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Sin detectar")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 6,
            y: 3
        )
    }
    
    // MARK: - Register Button
    
    private var registerButton: some View {
        Button {
            
        } label: {
            Label(
                registerButtonTitle,
                systemImage: registerButtonSystemImage
            )
            .font(.title3)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(registerButtonColor)
            .foregroundStyle(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .opacity(canRegisterAttendance ? 1 : 0.45)
        }
        .disabled(!canRegisterAttendance)
    }
    
    private var registerButtonTitle: String {
        switch viewModel.availableAttendanceType {
        case .entrada:
            return "Registrar entrada"
            
        case .salida:
            return "Registrar salida"
        }
    }
    
    private var registerButtonSystemImage: String {
        switch viewModel.availableAttendanceType {
        case .entrada:
            return "arrow.down.circle.fill"
            
        case .salida:
            return "arrow.up.circle.fill"
        }
    }
    
    private var registerButtonColor: Color {
        guard canRegisterAttendance else {
            return .gray
        }
        
        switch viewModel.availableAttendanceType {
        case .entrada:
            return .green
            
        case .salida:
            return .red
        }
    }
    
    private var canRegisterAttendance: Bool {
        viewModel.isFaceValidated &&
        viewModel.isLocationValidated
    }
    
    // MARK: - Message
    
    private var messageSection: some View {
        Text(viewModel.statusMessage)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 5,
                y: 2
            )
    }
    
    // MARK: - Toolbar
    
    @ToolbarContentBuilder
    private var adminToolbarButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isAdminLoginPresented = true
            } label: {
                Image(systemName: "lock.shield.fill")
                    .foregroundStyle(.blue)
            }
            .accessibilityLabel("Acceso de administrador")
        }
    }
    
    // MARK: - Sheets
    
    
    
    // MARK: - Actions
    
    private func registerAttendance()  {}
    
    // MARK: - Colors
    
    private var scannerStatusColor: Color {
        switch viewModel.scannerStatus {
        case "ROSTRO OK":
            return .green
            
        case "NO AUTORIZADO",
            "ERROR",
            "NO DETECTADO":
            return .red
            
        case "ESCANEANDO...":
            return .blue
            
        default:
            return .orange
        }
    }
}
