//
//  RunnerSpeedometerView.swift
//  RunRhythm
//
//  Created by Raman Kozar on 04/11/2024.
//
import Foundation
import SwiftUI

// Runner Speedometer View
//
struct RunnerSpeedometerView: View {
    
    // Using speed from LocationManager
    @StateObject private var locationManager = LocationManager()
    
    @State var currentSpeedFont: Font = UIScreen.main.bounds.height < 750 ? .title : .largeTitle
    
    var body: some View {
       
        ZStack {
            
            // Outer circle (speedometer)
            Circle()
                .stroke(lineWidth: 30)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Ring Progress
            Circle()
                .trim(from: 0.05, to: min(CGFloat(locationManager.speed * 3.6 / 20), 0.95))
                .stroke(AngularGradient(gradient: Gradient(stops: [
                    .init(color: Color.green.opacity(0.0), location: 0.0),
                    .init(color: Color.green, location: 0.2),
                    .init(color: Color.green, location: 0.3),
                    .init(color: Color.yellow, location: 0.4),
                    .init(color: Color.yellow, location: 0.5),
                    .init(color: Color.red, location: 0.6),
                    .init(color: Color.red, location: 0.7),
                    .init(color: Color.red.opacity(0.0), location: 1.0)
                ]), center: .center), lineWidth: 20)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut, value: locationManager.speed)
            
            // Current speed
            VStack {
                
                Text("\(String(format: "%.1f", locationManager.speed * 3.6)) km/h")
                    .font(currentSpeedFont)
                    .fontWeight(.bold)
                
                Text("Current Speed")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            
        }
        .padding(40)
        .onAppear {
            print("Speed view appeared with current speed: \(locationManager.speed * 3.6) km/h")
        }
        
    }
    
}