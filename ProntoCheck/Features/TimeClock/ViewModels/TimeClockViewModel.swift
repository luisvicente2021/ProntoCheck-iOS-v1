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
    
    @Published var availableAttendanceType: AttendanceType = .entrada
    
    @Published var scannerStatus = "ESPERANDO"
    @Published var statusMessage = "Coloca tu rostro frente a la cámara"
    
    @Published var isFaceValidated = false
    @Published var isLocationValidated = false
    
    @Published var currentTime = ""
    @Published var currentDate = ""
    
    func start() async {
        startClock()
    }
    
    private func startClock() { }
    
    private func updateDateTime() {
        
        let now = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "es_MX")
        timeFormatter.dateFormat = "hh:mm:ss a"
        
        currentTime = timeFormatter.string(from: now)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "EEEE d 'de' MMMM yyyy"
        
        currentDate = dateFormatter.string(from: now)
            .capitalized
    }
    
    func stopClock() { }
}
