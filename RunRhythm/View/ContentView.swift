//
//  ContentView.swift
//  RunRhythm
//
//  Created by Raman Kozar on 27/10/2024.
//

import SwiftUI

// Main Application View
//
struct ContentView: View {
    
    //0: km/h, 1: m/s, 2: mph
    @State private var optionValue: Int = 0
    
    // Getting ObservedObject of LocationViewModel
    @ObservedObject private var locationViewModel = LocationViewModel()
    
    private var speedCalculation = SpeedCalculations()
    
    // Options (scale): 0, 1, 2, 3
    @State private var speedometerScale: Int = 1
        
    @StateObject var runRhythmHome = RunRhythmHomeViewModel()
    @State var playerWidth: CGFloat = UIScreen.main.bounds.height < 750 ? 190 : 260
    @State private var isPlaying = false
    
    let flexibleConstant: CGFloat = 45
    
    let blackWhite  = Color.init("blackWhite", bundle: nil)
    let grayWhite   = Color.init("grayWhite", bundle: nil)
    let whiteBlack  = Color.init("whiteBlack", bundle: nil)
        
    // Current song
    @State var currentSongName: String = "Breath In"
    @State var currentAuthorSongName: String = "Armin van Buuren"
    @State var currentSongDuration = SongDuration(totalSeconds: 185)

    var body: some View {
        
        VStack {
        
            VStack {
                
                ZStack {
                    
                    Gauge(value: min(max(speedCalculation.getConvertSpeed(optionValue, locationViewModel.speed), 0), Double(speedCalculation.getMaximumSpeed(optionValue, speedometerScale))), in: 0...Double(speedCalculation.getMaximumSpeed(optionValue, speedometerScale))) {
                                            
                    } currentValueLabel: {
                        Text("")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("\(speedCalculation.getMaximumSpeed(optionValue, speedometerScale))")
                    }
                    .gaugeStyle(RunnerSpeedometerView())
                    .animation(.bouncy(duration: 0.3), value: optionValue)
                    .animation(.bouncy(duration: 0.3), value: speedometerScale)
                    
                    VStack(spacing: 10) {
                        
                        HStack(spacing: 15) {
                            
                            HStack(spacing: 3) {
                                
                                Text("\(String(format: "%.1f", locationViewModel.speed < 0 ? 0 : speedCalculation.getConvertSpeed(optionValue, locationViewModel.speed)))")
                                    .font(.system(size: 50))
                                    .padding(.leading)
                                
                                Text(speedCalculation.getSpeedOptionUnit(optionValue))
                                    .font(.system(size: 25))
                                    .offset(y: 7)
                                
                            }
                        }
                        .fontWeight(.semibold)
                    }
                    .padding()
                    .animation(.bouncy(duration: 0.3), value: optionValue)
                    
                }
                .onTapGesture {
                    optionValue = (optionValue + 1) % 3
                }
                
                Picker("", selection: $speedometerScale) {
                    Text("\(speedCalculation.getMaximumSpeed(optionValue, 0))").tag(0)
                    Text("\(speedCalculation.getMaximumSpeed(optionValue, 1))").tag(1)
                    Text("\(speedCalculation.getMaximumSpeed(optionValue, 2))").tag(2)
                    Text("\(speedCalculation.getMaximumSpeed(optionValue, 3))").tag(3)
                }
                .pickerStyle(.segmented)
                .containerRelativeFrame(.horizontal, count: 5, span: 3, spacing: 0)
                .containerRelativeFrame(.vertical, count: 1, span: 0, spacing: 0)
                
            }
            .containerRelativeFrame(.vertical, count: 9, span: 4, spacing: 0)
            
            ZStack {
                
                Image(uiImage: UIImage(named: "avb_test")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: playerWidth, height: playerWidth)
                    .clipShape(Circle())
                
                ZStack {
                    
                    Circle()
                        .trim(from: 0, to: 0.8)
                        .stroke(grayWhite.opacity(0.2), lineWidth: 4)
                        .frame(width: playerWidth + flexibleConstant, height: playerWidth + flexibleConstant)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(runRhythmHome.currentAngle) / 360)
                        .stroke(blackWhite, lineWidth: 4)
                        .frame(width: playerWidth + flexibleConstant, height: playerWidth + flexibleConstant)
                    
                    Circle()
                        .fill(blackWhite)
                        .frame(width: 20, height: 30)
                        .offset(x: (playerWidth + flexibleConstant) / 2)
                        .rotationEffect(.init(degrees: runRhythmHome.currentAngle))
                        .gesture(DragGesture().onChanged(runRhythmHome.onChanged(value:)))
                    
                }
                .rotationEffect(.init(degrees: 126))
               
                Text("0:00")
                    .fontWeight(.semibold)
                    .foregroundColor(blackWhite)
                    .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (playerWidth + 60) / 2)
                
                Text(currentSongDuration.formatted)
                    .fontWeight(.semibold)
                    .foregroundColor(blackWhite)
                    .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (playerWidth + 60) / 2)
                
            }
            .padding(.top, -30)
            
            Text(currentSongName)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(blackWhite)
                .padding(.top, 25)
                .padding(.horizontal)
                .lineLimit(1)
            
            Text(currentAuthorSongName)
                .foregroundColor(.gray)
                .padding(.top, -10)
            
            HStack(spacing: 45) {
                
                Button(action: {}) {
                    
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                }
                
                Button(action: togglePlayPause) {
                    
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(whiteBlack)
                        .padding()
                        .background(blackWhite)
                        .clipShape(Circle())
                    
                }
                
                Button(action: {}) {
                    
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                }
                
            }
            
        }
        .padding(.top, -40)
        .monospacedDigit()
        .font(.system(size: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6).opacity(0.7))
        
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
}

#Preview {
    ContentView()
}
