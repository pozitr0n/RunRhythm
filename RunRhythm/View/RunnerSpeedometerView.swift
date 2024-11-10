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
struct RunnerSpeedometerView: GaugeStyle {
    
    @State var runnerSpeedometerWidth: CGFloat = UIScreen.main.bounds.height < 750 ? 210 : 230
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color(.systemGray5), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75*configuration.value)
                .stroke(AngularGradient(colors: [.blue, .cyan], center: .center, angle: .degrees(-5)), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(135))
            
            VStack {
                
                Spacer()
                
                HStack {
                    configuration.minimumValueLabel
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    configuration.maximumValueLabel
                        .frame(width: 80, alignment: .trailing)
                }
                .frame(width: 160, height: 65, alignment: .top)
                
            }
            
        }
        .frame(width: runnerSpeedometerWidth, height: runnerSpeedometerWidth)
        
    }
    
}
