//
//  RootView.swift
//  ProntoCheck
//
//  Created by luisr on 05/07/26.
//
import SwiftUI

struct RootView: View {

    @ObservedObject var sessionManager: SessionManager
    let authViewModel: AuthViewModel

    var body: some View {
        if sessionManager.isAuthenticated {
            VStack {
                Text("✅ Login exitoso")
                Text(sessionManager.currentUser?.email ?? "")
            }
        } else {
            LoginView(viewModel: authViewModel)
        }
    }
}
