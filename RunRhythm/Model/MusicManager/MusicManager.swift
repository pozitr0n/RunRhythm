//
//  MusicManager.swift
//  RunRhythm
//
//  Created by Raman Kozar on 09/02/2025.
//


import MediaPlayer

class MusicManager: ObservableObject {
    
    private let player = MPMusicPlayerController.applicationQueuePlayer
    @Published var currentTrack: MPMediaItem?
    @Published var availablePlaylists: [MPMediaPlaylist] = []
    
    init() {
        requestPermissions()
    }
    
    func requestPermissions() {
        MPMediaLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.loadPlaylists()
                } else {
                    print("Access to the media library is denied!")
                }
            }
        }
    }
    
    func loadPlaylists() {
        let playlistsQuery = MPMediaQuery.playlists()
        guard let playlists = playlistsQuery.collections as? [MPMediaPlaylist] else {
            print("Playlists not found")
            return
        }
        
        DispatchQueue.main.async {
            self.availablePlaylists = playlists
        }
    }
    
    func findSongsMatchingTempo(targetBPM: Double, playlist: MPMediaPlaylist) -> [MPMediaItem] {
        return playlist.items.filter { item in
            if let bpm = item.value(forProperty: MPMediaItemPropertyBeatsPerMinute) as? Int {
                return Double(bpm) == targetBPM
            }
            return false
        }
    }
    
    func adjustPlaybackToMatch(targetPace: Double) {
        let targetBPM = targetPace * 60.0
        
        guard let currentPlaylist = availablePlaylists.first else {
            print("No playlists available")
            return
        }
        
        let matchingSongs = findSongsMatchingTempo(targetBPM: targetBPM, playlist: currentPlaylist)
        
        guard !matchingSongs.isEmpty else {
            print("No songs with BPM \(targetBPM)")
            return
        }
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: MPMediaItemCollection(items: matchingSongs))
        
        player.setQueue(with: descriptor)
        player.prepareToPlay()
        player.play()
        
        DispatchQueue.main.async {
            self.currentTrack = matchingSongs.first
        }
        
    }
    
    func pausePlayback() {
        player.pause()
    }
    
    func resumePlayback() {
        player.play()
    }
    
}
