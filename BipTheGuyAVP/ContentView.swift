//
//  ContentView.swift
//  BipTheGuyAVP
//
//  Created by Bob Witmer on 2025-08-08.
//

import SwiftUI
import AVFAudio
import PhotosUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isFullSize: Bool = true
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage: Image = Image("clown")
    
    var body: some View {
        
        VStack {
            Spacer()
            bipImage
                .resizable()
                .scaledToFit()
                .scaleEffect(isFullSize ? 1.0 : 0.9)
                .onTapGesture {
                    playSound(soundName: "punchSound")
                    isFullSize.toggle()
                    withAnimation (.spring(response: 0.3, dampingFraction: 0.3)) {
                        isFullSize.toggle()
                    }
                }
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
            }
            .onChange(of: selectedPhoto) {
                Task {
                    guard let selectedImage = try? await
                            selectedPhoto?.loadTransferable(type: Image.self) else {
                        print("😡 ERROR: Could not get Image from loadTransferable")
                        return
                    }
                    // Success
                    bipImage = selectedImage
                }
            }
            
            Spacer()


        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 ERROR: Could not read sound file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: -> \(error.localizedDescription) creating AVAudioPlayer")
        }
    }
    
    func stopSound() {
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
