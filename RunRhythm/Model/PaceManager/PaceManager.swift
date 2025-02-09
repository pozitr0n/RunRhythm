//
//  PaceManager.swift
//  RunRhythm
//
//  Created by Raman Kozar on 09/02/2025.
//

import Foundation
import Combine

class PaceManager: ObservableObject {
    
    @Published var currentPace: Double = 0.0
    @Published var targetPace: Double = 0.0
    @Published var paceStatus: PaceStatus = .onTarget
    
    private let healthKitManager: HealthKitManager
    private let musicManager: MusicManager
    private var cancellables = Set<AnyCancellable>()
    
    enum PaceStatus {
        case tooSlow
        case onTarget
        case tooFast
    }
    
    init(healthKitManager: HealthKitManager, musicManager: MusicManager) {
        self.healthKitManager = healthKitManager
        self.musicManager = musicManager
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        healthKitManager.$currentPace
            .sink { [weak self] pace in
                self?.updatePace(pace)
            }
            .store(in: &cancellables)
    }
    
    private func updatePace(_ newPace: Double) {
        currentPace = newPace
        
        let idealPace = healthKitManager.calculateIdealPace(currentHeartRate: healthKitManager.currentHeartRate)
        targetPace = idealPace
        
        let paceThreshold = 0.2 // 20% tolerance
        
        if abs(currentPace - idealPace) / idealPace <= paceThreshold {
            paceStatus = .onTarget
        } else if currentPace < idealPace {
            paceStatus = .tooSlow
        } else {
            paceStatus = .tooFast
        }
        
        musicManager.adjustPlaybackToMatch(targetPace: idealPace)
    }
    
    func getPaceRecommendation() -> String {
        switch paceStatus {
        case .tooSlow:
            return "Speed up! Try to match the music's rhythm"
        case .onTarget:
            return "Great pace! Keep it up"
        case .tooFast:
            return "Slow down a bit to match your target pace"
        }
    }
    
    func formatPace(_ pace: Double) -> String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d min/km", minutes, seconds)
    }
}
