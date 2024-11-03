//
//  RunRhythmHomeViewModel.swift
//  RunRhythm
//
//  Created by Raman Kozar on 03/11/2024.
//

import Foundation
import SwiftUI

class RunRhythmHomeViewModel: ObservableObject {
    
    @Published var currentAngle: Double = 0
    
    func onChanged(value: DragGesture.Value) {
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
        let temAngle = radians * 180 / .pi
        let currentAngle = temAngle < 0 ? 360 + temAngle : temAngle
        
        if currentAngle <= 288 {
            withAnimation(Animation.linear(duration: 0.1)) {
                self.currentAngle = Double(currentAngle)
            }
        }
        
    }
    
}
