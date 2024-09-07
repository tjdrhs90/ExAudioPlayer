//
//  ViewModel.swift
//  ExAudioPlayer
//
//  Created by 심성곤 on 9/7/24.
//

import Foundation
import AVKit

/// 오디오 뷰모델
@Observable final class ViewModel {
    
    var player: AVAudioPlayer?
    var isPlaying = false
    var totalTime: TimeInterval = 0.0
    var currentTime: TimeInterval = 0.0
    var timer: Timer?
    
    init() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "wav") else { return }
        setupAudio(withURL: url)
    }
    
    private func setupAudio(withURL url: URL) {
        do {
            // 무음모드에서도 재생되도록 설정
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true) // 오디오 세션 활성화. 앱이 백그라운드로 이동하거나 중단되었을 때, 다시 활성화해야함
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    func play() {
        guard let player else { return }
        isPlaying = true
        player.play()
        startTimer()
    }
    
    func pause() {
        guard let player else { return }
        isPlaying = false
        player.pause()
        stopTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateProgress() {
        guard let player else { return }
        
        currentTime = player.currentTime
        
        if !player.isPlaying {
            pause()
            currentTime = 0
        }
    }
}
