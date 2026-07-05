//
//  AdminLoginView.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//

import SwiftUI

    struct LoginView: View {

        @StateObject private var viewModel: AuthViewModel

        init(viewModel: AuthViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }

        var body: some View {
            VStack {
                TextField("Correo", text: $viewModel.email)

                SecureField("Contraseña", text: $viewModel.password)

                Button("Iniciar sesión") {
                    Task {
                        await viewModel.login()
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .padding()
        }
    }
