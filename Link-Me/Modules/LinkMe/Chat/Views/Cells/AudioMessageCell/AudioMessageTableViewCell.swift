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
    
    private var player: AVAudioPlayer?
    private var audioURL: URL?
    private var audioIsPlayed: Bool = false
    private var audioCurrentTime: TimeInterval = 0.0
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAudioVisualization()
    }
    
    // MARK: Updates
    
    func update(_ item: MessageModel) {
        guard let audioPath = item.messages?.path else { return }
        downloadFileFromURL(url: NSURL(string: audioPath)!)
        guard let url = audioURL else { return }
        player = try! AVAudioPlayer(contentsOf: url)
        configureAudioVisualization()
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
    
    func downloadFileFromURL(url:NSURL){

        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.audioURL = URL //self?.play(URL)
        })
        downloadTask.resume()
    }

    // MARK: Actions
    
    @IBAction private func didTappedOnActiveButton(_ sender: Any) {
        playAudio()
    }
}


// MARK: Configurations

extension AudioMessageTableViewCell {
    private func playAudio() {
        guard let player = player else { return }
        
        if audioIsPlayed {
            audioCurrentTime = player.currentTime
            player.pause()
            activeButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.audioVisualizationView.pause()
            self.audioIsPlayed = false
        }
        else {
            player.play()
            activeButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.audioVisualizationView.play(for: player.duration)
            self.audioIsPlayed = true
        }
    }
    
    private func configureAudioVisualization() {
        self.audioVisualizationView.meteringLevelBarWidth = 2.8
        self.audioVisualizationView.meteringLevelBarInterItem = 3.0
        self.audioVisualizationView.meteringLevelBarCornerRadius = 3.0
        
        self.audioVisualizationView.gradientStartColor = UIColor(hexString: "#A88DF3")
        self.audioVisualizationView.gradientEndColor = .white
        
        self.audioVisualizationView.audioVisualizationMode = .read
//        self.audioVisualizationView.audioVisualizationTimeInterval = player?.duration ?? 0
        self.audioVisualizationView.meteringLevels = [0.40, 0.67, 0.40, 0.56, 0.84, 0.48, 0.53, 0.56, 0.62, 0.40, 0.40, 0.67, 0.56, 0.84, 0.48, 0.53, 0.56, 0.62, 0.40, 0.40, 0.67, 0.40, 0.23]
    }
}
