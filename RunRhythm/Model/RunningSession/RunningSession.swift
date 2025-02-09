//
//  RunningSession.swift
//  RunRhythm
//
//  Created by Raman Kozar on 09/02/2025.
//

import Foundation
import Combine

class RunningSession: ObservableObject {
    
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var distance: Double = 0
    @Published var calories: Double = 0
    
    private let healthKitManager: HealthKitManager
    private let paceManager: PaceManager
    private var timer: Timer?
    private var startTime: Date?
    
    init(healthKitManager: HealthKitManager, paceManager: PaceManager) {
        self.healthKitManager = healthKitManager
        self.paceManager = paceManager
    }
    
    func startSession() {
        
        isRunning = true
        startTime = Date()
        healthKitManager.startMonitoring()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
        
    }
    
    func pauseSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resumeSession() {
       
        isRunning = true
        startTime = Date().addingTimeInterval(-elapsedTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
        
    }
    
    func endSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        distance = 0
        calories = 0
        startTime = nil
    }
    
    private func updateElapsedTime() {
        guard let start = startTime else { return }
        elapsedTime = Date().timeIntervalSince(start)
    }
    
    func formatElapsedTime() -> String {
        
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
    }
    
}
