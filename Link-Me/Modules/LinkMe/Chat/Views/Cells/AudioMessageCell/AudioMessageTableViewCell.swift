//
//  AudioMessageTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/11/2023.
//

import UIKit
import SoundWave
import AVFoundation

class AudioMessageTableViewCell: UITableViewCell {

    
    // MARK: Outlets
    
    @IBOutlet private weak var messageStackView: UIStackView!
    @IBOutlet private weak var activeButton: UIButton!
    @IBOutlet private weak var audioVisualizationView: AudioVisualizationView!
    @IBOutlet private weak var recordDurationLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
   
    // MARK: Proprites
    
    private var player: AVPlayer?
    private var audioIsPlayed: Bool = false
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAudioVisualization()
    }
    
    // MARK: Updates
    
    func update(_ item: MessageModel) {
        guard let audioPath = item.messages?.path,
              let url = NSURL(string: audioPath) else { return }
        player = AVPlayer(url: url as URL)
        updateUI(item)
    }
    
    private func updateUI(_ item: MessageModel) {
        guard let senderID = UDHelper.fetchUserData?.id else { return }
        
        if "\(senderID)" == item.SenderID {
            
            semanticContentAttribute = .forceRightToLeft
            messageStackView.alignment = .trailing
            
        } else {
            semanticContentAttribute = .forceLeftToRight
            messageStackView.alignment = .leading
        }
    }
  
    
    // MARK: Actions
    
    @IBAction private func didTappedOnActiveButton(_ sender: Any) {
        playAudio()
    }
}


// MARK: Configurations

extension AudioMessageTableViewCell {
    private func playAudio() {
       
        guard let player = player, let cmTimeDuration = player.currentItem?.duration else { return }
        let duration = Float(CMTimeGetSeconds((cmTimeDuration)))
        
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        if audioIsPlayed {
            player.pause()
            activeButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.audioVisualizationView.pause()
            self.audioIsPlayed = false
        }
        else {
            player.play()
            activeButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.audioVisualizationView.play(for: TimeInterval(duration))
            self.audioIsPlayed = true
        }
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("playerDidFinishPlaying")
        audioIsPlayed = false
    }
    
    private func configureAudioVisualization() {
        self.audioVisualizationView.meteringLevelBarWidth = 2.8
        self.audioVisualizationView.meteringLevelBarInterItem = 3.0
        self.audioVisualizationView.meteringLevelBarCornerRadius = 3.0
        
        self.audioVisualizationView.gradientStartColor = UIColor(hexString: "#A88DF3")
        self.audioVisualizationView.gradientEndColor = .white
        
        self.audioVisualizationView.audioVisualizationMode = .read
        self.audioVisualizationView.meteringLevels = [0.40, 0.67, 0.40, 0.56, 0.84, 0.48, 0.53, 0.56, 0.62, 0.40, 0.40, 0.67, 0.56, 0.84, 0.48, 0.53, 0.56, 0.62, 0.40, 0.40, 0.67, 0.40, 0.23]
    }
}
