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
    
    @StateObject var runRhythmHome = RunRhythmHomeViewModel()
    
    @State var playerWidth: CGFloat = UIScreen.main.bounds.height < 750 ? 200 : 270
    @State var runnerSpeedometerWidth: CGFloat = UIScreen.main.bounds.height < 750 ? 265 : 285
    
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
                
                RunnerSpeedometerView()
                    .frame(width: runnerSpeedometerWidth, height: runnerSpeedometerWidth)
                
            }
            .padding(.top, -30)
            
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
                        .frame(width: 30, height: 30)
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
            .padding(.top, -20)
            
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

    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
}

#Preview {
    ContentView()
}
