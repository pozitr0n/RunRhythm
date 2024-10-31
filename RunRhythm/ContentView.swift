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
    @State var width: CGFloat = UIScreen.main.bounds.height < 750 ? 250 : 300
    @State private var isPlaying = false
    
    let flexibleConstant: CGFloat = 45
    
    let blackWhite = Color.init("blackWhite", bundle: nil)
    let grayWhite = Color.init("grayWhite", bundle: nil)

    @State var progress: CGFloat = 0
    let colors = [Color.init("blackGray", bundle: nil),
                  Color.init("grayLightGray", bundle: nil),
                  Color.red]
    
    var body: some View {
        
        VStack {
            
            Spacer(minLength: 0)
        
            VStack {
                
                Meter(progress: self.$progress)
                
                HStack(spacing: 15) {
                    
                    Button(action: {
                        if self.progress != 100 {
                            withAnimation(Animation.default.speed(0.55)) {
                                self.progress += 10
                            }
                        }
                    }) {
                        Text("Update")
                            .padding(.vertical)
                            .foregroundColor(blackWhite)
                            .frame(width: (UIScreen.main.bounds.width)/4, height: 35)
                    }
                    
                    .background(Capsule().stroke(self.colors[0], lineWidth: 2))
                    .padding()
                    .padding(.top, 20)
                    
                    Button(action: {
                        withAnimation(Animation.default.speed(0.55)) {
                            self.progress = 0
                        }
                    }) {
                        Text("Reset")
                            .padding(.vertical)
                            .foregroundColor(blackWhite)
                            .frame(width: (UIScreen.main.bounds.width)/4, height: 35)
                    }
                    .background(Capsule().stroke(self.colors[0], lineWidth: 2))
                    .padding()
                    .padding(.top, 20)
                    
                }
                
            }
            
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
            
            Text("Breath In")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(blackWhite)
                .padding(.top, 25)
                .padding(.horizontal)
                .lineLimit(1)
            
            Text("Armin van Buuren")
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            HStack(spacing: 55) {
                
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
            .padding(.top, 25)
            
            Spacer(minLength: 0)
            
        }

    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
}

struct Meter: View {
    
    @Binding var progress: CGFloat
    let colors = [Color.init("blackGray", bundle: nil),
                  Color.init("grayLightGray", bundle: nil),
                  Color.red]
    
    let blackWhite = Color.init("blackWhite", bundle: nil)
    let grayWhite = Color.init("grayWhite", bundle: nil)
    
    var body: some View {
        
        ZStack {
            
            // Circular progress bar
            ZStack {
                
                Circle()
                    .trim(from: 0, to: 0.5)
                    .stroke(blackWhite.opacity(0.2), lineWidth: 35)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: self.setProgress())
                    .stroke(AngularGradient(gradient: .init(colors: self.colors), center: .center, angle: .init(degrees: 180)), lineWidth: 35)
                    .frame(width: 200, height: 200)
                
            }
            .rotationEffect(.init(degrees: 180))
            
            // Arrow indicator
            ZStack (alignment: .bottom) {
                
                // Arrow stem
                self.colors[0]
                    .frame(width: 2, height: 75)
                
                // Arrow head
                Circle()
                    .fill(self.colors[1])
                    .frame(width: 15, height: 15)
                
            }
            .offset(y: -35)
            .rotationEffect(.init(degrees: -90))
            .rotationEffect(.init(degrees: self.setArrow()))
            
        }
        .padding()
        .padding(.bottom, -140)
        
    }
    
    // Calculate progress for the circular bar
    func setProgress() -> CGFloat {
        let temp = self.progress / 2
        return (temp * 0.01)
    }
    
    // Calculate rotation for the arrow indicator
    func setArrow() -> Double {
        let temp = self.progress/100
        return (temp * 180)
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

#Preview {
    ContentView()
}
