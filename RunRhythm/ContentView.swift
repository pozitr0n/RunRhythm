//
//  ContentView.swift
//  RunRhythm
//
//  Created by Raman Kozar on 27/10/2024.
//

import SwiftUI

// Test content view
//
struct ContentView: View {
    
    @StateObject var runRhythmHome = RunRhythmHomeViewModel()
    @State var width: CGFloat = UIScreen.main.bounds.height < 750 ? 200 : 270
    @State var widthAnother: CGFloat = UIScreen.main.bounds.height < 750 ? 265 : 285
    @State private var isPlaying = false
    
    let flexibleConstant: CGFloat = 45
    
    let blackWhite = Color.init("blackWhite", bundle: nil)
    let grayWhite = Color.init("grayWhite", bundle: nil)

    var body: some View {
        
        VStack {
        
            VStack {
                
                RunnerSpeedometerView()
                    .frame(width: widthAnother, height: widthAnother)
                
            }
            .padding(.top, -30)
            
            ZStack {
                
                Image(uiImage: UIImage(named: "avb_test")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipShape(Circle())
                
                ZStack {
                    
                    Circle()
                        .trim(from: 0, to: 0.8)
                        .stroke(grayWhite.opacity(0.2), lineWidth: 4)
                        .frame(width: width + flexibleConstant, height: width + flexibleConstant)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(runRhythmHome.currentAngle) / 360)
                        .stroke(blackWhite, lineWidth: 4)
                        .frame(width: width + flexibleConstant, height: width + flexibleConstant)
                    
                    Circle()
                        .fill(blackWhite)
                        .frame(width: 30, height: 30)
                        .offset(x: (width + flexibleConstant) / 2)
                        .rotationEffect(.init(degrees: runRhythmHome.currentAngle))
                        .gesture(DragGesture().onChanged(runRhythmHome.onChanged(value:)))
                    
                }
                .rotationEffect(.init(degrees: 126))
               
                Text("0:00")
                    .fontWeight(.semibold)
                    .foregroundColor(blackWhite)
                    .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85 , y: (width + 60) / 2)
                
                Text("3:00")
                    .fontWeight(.semibold)
                    .foregroundColor(blackWhite)
                    .offset(x: UIScreen.main.bounds.height < 750 ? 65 : 85 , y: (width + 60) / 2)
                
            }
            .padding(.top, -20)
            
            Text("Breath In")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(blackWhite)
                .padding(.top, 25)
                .padding(.horizontal)
                .lineLimit(1)
            
            Text("Armin van Buuren")
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
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                    
                }
                
                Button(action: {}) {
                    
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                }
                
            }
            
        }

    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
}

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

struct RunnerSpeedometerView: View {
    
    @State private var currentSpeed: Double = 6.0 // runner's current pace
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
                .trim(from: 0.0, to: min(CGFloat(currentSpeed / 12), 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [.green, .yellow, .red]),
                                        center: .center), lineWidth: 20)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut, value: currentSpeed)
            
            // Current tempo
            VStack {
                Text("\(String(format: "%.1f", currentSpeed)) km/h")
                    .font(currentSpeedFont)
                    .fontWeight(.bold)
                
                Text("Current Speed")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
        }
        .padding(40)
        .onAppear {
            
            // Emulate tempo change
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.currentSpeed = Double.random(in: 0...25)
            }
            
        }
        
    }
    
}

#Preview {
    ContentView()
}
