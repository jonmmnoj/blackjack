//
//  SoundPlayer.swift
//  BlackJackPracticeStrategyGame
//
//  Created by Jon on 12/7/21.
//

import AVFoundation

class SoundPlayer {
    static var shared = SoundPlayer()
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
        let path = Bundle.main.path(forResource: "deal.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        player = try! AVAudioPlayer(contentsOf: url)
    }
    
    var player: AVAudioPlayer = AVAudioPlayer()
    func playSound(type: SoundType) {
        var fileName = ""
        switch type {
        case .deal: fileName = "deal2.mp3"
        case .flip: fileName = "flip.mp3"
        case .discard: fileName = "clear2.mp3"
        case .shuffle: fileName = "shuffle.mp3"
        case .chips: fileName = "chips.mp3"
        }
        let path = Bundle.main.path(forResource: fileName, ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch { }
    }
}

enum SoundType {
    case deal, flip, discard, shuffle, chips
}

