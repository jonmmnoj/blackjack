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
        //queuePlayer.play()
    }
    
    func getFileName(for type: SoundType) -> String {
        var fileName = ""
        switch type {
        case .deal: fileName = "deal2.mp3"
        case .flip: fileName = "flip.mp3"
        case .discard: fileName = "clear2.mp3"
        case .shuffle: fileName = "shuffle.mp3"
        case .chips: fileName = "chips.mp3"
        case .click: fileName = "click.mp3"
        }
        return fileName
    }
    
    var player: AVAudioPlayer = AVAudioPlayer()
    func playSound(_ type: SoundType) {
        guard Settings.shared.soundOn else { return }
        let path = Bundle.main.path(forResource: getFileName(for: type), ofType: nil)!
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print(error)
        }
    }
    
    var queuePlayer: AVQueuePlayer = AVQueuePlayer()
    func playSounds(_ array: [SoundType]) {
        guard Settings.shared.soundOn else { return }
        var audioItems: [AVPlayerItem] = []
        for type in array {
            let path = Bundle.main.path(forResource: getFileName(for: type), ofType: nil)!
            let url = URL(fileURLWithPath: path)
            //let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioName, ofType: "mp3")!)
            let item = AVPlayerItem(url: url)
            audioItems.append(item)
        }
        
        queuePlayer = AVQueuePlayer(items: audioItems)
       //queuePlayer.play()
    }
        
}

enum SoundType {
    case deal, flip, discard, shuffle, chips, click
}

