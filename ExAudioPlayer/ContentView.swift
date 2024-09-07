//
//  ContentView.swift
//  ExAudioPlayer
//
//  Created by 심성곤 on 9/7/24.
//

import SwiftUI

// https://ahmetkasimnazli.medium.com/creating-an-audio-player-with-avkit-in-swiftui-a17f3b704fad
// 오디오 플레이어
struct ContentView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if viewModel.isPlaying {
                        viewModel.pause()
                    } else {
                        viewModel.play()
                    }
                } label: {
                    Image(systemName: viewModel.isPlaying ? "pause.circle" : "play.circle")
                        .font(.largeTitle)
                }
                
                Slider(value: $viewModel.currentTime, in: 0...viewModel.totalTime) { editing in
                    if editing {
                        if viewModel.isPlaying {
                            viewModel.pause()
                        }
                    } else {
                        viewModel.player?.currentTime = viewModel.currentTime
                        viewModel.play()
                    }
                }
            }
            
            HStack {
                Text("\(formatTime(viewModel.currentTime))")
                Spacer()
                Text("\(formatTime(viewModel.totalTime))")
            }
        }
        .animation(.linear(duration: 0.1), value: viewModel.currentTime)
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
