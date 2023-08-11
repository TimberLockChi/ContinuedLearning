//
//  SoundBootcamp.swift
//  ContinuedLearning
//
//  Created by Chi Tim on 2023/8/10.
//

import SwiftUI
import AVKit//音频、视频工具

class SoundManager:ObservableObject{
    
    static let instance = SoundManager()//单例模式
    
    var player: AVAudioPlayer?
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "tada", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
        
    }
}


struct SoundBootcamp: View {
    
    var body: some View {
        VStack(spacing:40){
            Button("Play Sound 1") {
                SoundManager.instance.playSound()
            }
            Button("Play Sound 2") {
                
            }
        }
    }
}

struct SoundBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SoundBootcamp()
    }
}
