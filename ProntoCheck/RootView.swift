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
    let timeClockViewModel: TimeClockViewModel
    let employeeFaceEnrollmentViewModel: EmployeeFaceEnrollmentViewModel
    
    var body: some View {
        if sessionManager.isAuthenticated {
            NavigationStack {
                TimeClockView(viewModel: timeClockViewModel,
                              employeeFaceEnrollmentViewModel: employeeFaceEnrollmentViewModel
                )
            }
        } else {
            LoginView(viewModel: authViewModel)
        }
    }
}
