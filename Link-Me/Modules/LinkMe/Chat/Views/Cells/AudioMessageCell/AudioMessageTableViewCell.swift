//
//  AudioMessageTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/11/2023.
//

import UIKit
import AVFoundation

class AudioMessageTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    // MARK: Proprites
    
    var player: AVAudioPlayer!
    var path: String!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    // MARK: Updates
    
    
    // MARK: Actions
    
    @IBAction private func didTappedOnActiveButton(_ sender: Any) {
//        let url = Bundle.main.url(forResource: "sunrise-groove-176565", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: path, withExtension: "mp3")!)

        player.play()
    }
}
