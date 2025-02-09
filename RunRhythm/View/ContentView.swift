//
//  ContentView.swift
//  RunRhythm
//
//  Created by Raman Kozar on 09/02/2025.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var musicManager = MusicManager()
    @StateObject private var paceManager: PaceManager
    @StateObject private var runningSession: RunningSession
    
    init() {
        let healthKit = HealthKitManager()
        let music = MusicManager()
        let pace = PaceManager(healthKitManager: healthKit, musicManager: music)
        let session = RunningSession(healthKitManager: healthKit, paceManager: pace)
        
        _healthKitManager = StateObject(wrappedValue: healthKit)
        _musicManager = StateObject(wrappedValue: music)
        _paceManager = StateObject(wrappedValue: pace)
        _runningSession = StateObject(wrappedValue: session)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !healthKitManager.isAuthorized {
                    AuthorizationView()
                } else {
                    RunningMetricsView(
                        paceManager: paceManager,
                        runningSession: runningSession
                    )
                    
                    MusicControlView(
                        musicManager: musicManager,
                        currentTrack: musicManager.currentTrack
                    )
                    
                    RunningControlsView(runningSession: runningSession)
                }
            }
            .padding()
            .navigationTitle("RunRhythm")
        }
    }
}

struct AuthorizationView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Health Data Access Required")
                .font(.title2)
                .padding()
            
            Text("Please enable Health access in Settings to use RunRhythm")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct RunningMetricsView: View {
    @ObservedObject var paceManager: PaceManager
    @ObservedObject var runningSession: RunningSession
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                MetricView(
                    title: "Current Pace",
                    value: paceManager.formatPace(paceManager.currentPace)
                )
                
                MetricView(
                    title: "Target Pace",
                    value: paceManager.formatPace(paceManager.targetPace)
                )
            }
            
            HStack {
                MetricView(
                    title: "Distance",
                    value: String(format: "%.2f km", runningSession.distance)
                )
                
                MetricView(
                    title: "Time",
                    value: runningSession.formatElapsedTime()
                )
            }
            
            PaceRecommendationView(paceManager: paceManager)
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct PaceRecommendationView: View {
    @ObservedObject var paceManager: PaceManager
    
    var recommendationColor: Color {
        switch paceManager.paceStatus {
        case .tooSlow: return .orange
        case .onTarget: return .green
        case .tooFast: return .red
        }
    }
    
    var body: some View {
        Text(paceManager.getPaceRecommendation())
            .font(.headline)
            .foregroundColor(recommendationColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(recommendationColor.opacity(0.1))
            .cornerRadius(10)
    }
}

struct MusicControlView: View {
    @ObservedObject var musicManager: MusicManager
    let currentTrack: MPMediaItem?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Now Playing")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(currentTrack?.title ?? "No Track Selected")
                .font(.headline)
                .lineLimit(1)
            
            Text(currentTrack?.artist ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RunningControlsView: View {
    @ObservedObject var runningSession: RunningSession
    
    var body: some View {
        HStack(spacing: 20) {
            if runningSession.isRunning {
                Button(action: { runningSession.pauseSession() }) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                }
            } else {
                Button(action: {
                    if runningSession.elapsedTime > 0 {
                        runningSession.resumeSession()
                    } else {
                        runningSession.startSession()
                    }
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }
            }
            
            Button(action: { runningSession.endSession() }) {
                Image(systemName: "stop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
