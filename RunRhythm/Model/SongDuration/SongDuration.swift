//
//  SongDuration.swift
//  RunRhythm
//
//  Created by Raman Kozar on 04/11/2024.
//

// Struct for saving song duration for displaying
//
struct SongDuration {
    
    let minutes: Int
    let seconds: Int
    
    // The initializer takes the total number of seconds
    init(totalSeconds: Int) {
        self.minutes = totalSeconds / 60
        self.seconds = totalSeconds % 60
    }
    
    // Format method
    var formatted: String {
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}
