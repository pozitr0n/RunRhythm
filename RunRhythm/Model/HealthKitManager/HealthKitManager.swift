//
//  HealthKitManager.swift
//  RunRhythm
//
//  Created by Raman Kozar on 09/02/2025.
//


import HealthKit
import Combine

class HealthKitManager: ObservableObject {
   
    private let healthStore = HKHealthStore()
    private let runningSpeed = HKQuantityType(.runningSpeed)
    private let heartRate = HKQuantityType(.heartRate)
    
    @Published var currentPace: Double = 0.0
    @Published var currentHeartRate: Double = 0.0
    @Published var isAuthorized = false
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        
        let typesToRead: Set = [
            runningSpeed,
            heartRate
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
            }
        }
        
    }
    
    func startMonitoring() {
        startMonitoringPace()
        startMonitoringHeartRate()
    }
    
    private func startMonitoringPace() {
        
        let query = HKAnchoredObjectQuery(
            type: runningSpeed,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            if let latestSample = samples.last {
                DispatchQueue.main.async {
                    // Create a unit for meters per second (m/s)
                    let metersPerSecond = HKUnit.meter().unitDivided(by: HKUnit.second())
                    let speedInMetersPerSecond = latestSample.quantity.doubleValue(for: metersPerSecond)
                    
                    // Convert to minutes per kilometer
                    if speedInMetersPerSecond > 0 {
                        let paceInMinutesPerKm = (1000.0 / speedInMetersPerSecond) / 60.0
                        self?.currentPace = paceInMinutesPerKm
                    } else {
                        self?.currentPace = 0
                    }
                }
            }
        }
        
        healthStore.execute(query)
        
    }
    
    private func startMonitoringHeartRate() {
        
        let query = HKAnchoredObjectQuery(
            type: heartRate,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            
            if let latestSample = samples.last {
                DispatchQueue.main.async {
                    self?.currentHeartRate = latestSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func calculateIdealPace(currentHeartRate: Double) -> Double {
        
        let maxHeartRate = 220.0 - 30.0 // Assuming age 30 for example
        let targetHeartRateZone = 0.75 // 75% of max heart rate for optimal training
        
        let targetHeartRate = maxHeartRate * targetHeartRateZone
        let paceAdjustmentFactor = currentHeartRate / targetHeartRate
        
        return currentPace * paceAdjustmentFactor
        
    }
    
}
