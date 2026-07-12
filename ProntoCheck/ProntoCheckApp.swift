//
//  ProntoCheckApp.swift
//  ProntoCheck
//
//  Created by usuario on 04/07/26.
//

import SwiftUI

@main
struct ProntoCheckApp: App {

    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView(
                        sessionManager: container.sessionManager,
                        authViewModel: container.authViewModel,
                        timeClockViewModel: container.timeClockViewModel
                    )
        }
    }
}
