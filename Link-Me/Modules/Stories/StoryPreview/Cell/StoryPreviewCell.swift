//
//  StoryPreviewCell.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

class StoryPreviewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView_iv: UIImageView!
    
    var nextStory: (()->())?
    var previousStory: (()->())?
    var isScrolled: Bool = false
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView_iv.image = nil

    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("next story")
        nextStory?()
    }

    @IBAction func previousStoryTapped(_ sender: Any) {
        print("previousStoryTapped")
        previousStory?()
    }
}


// MARK: Configuration

extension StoryPreviewCell {
    func update(_ item: Stories) {
        switch item.video?.getPathExtensionType() {
        case .video:
            configureVideoStory(item)
        case .image:
            configureImageStory(item)
        default:
            // TODO: - Need to handle if path extension is not valid.
            break
        }
    }
}


// MARK: Private Handlers

extension StoryPreviewCell {
    private func configureVideoStory(_ item: Stories) {
        self.imageView_iv.isHidden = true
        self.videoView.isHidden = false
        guard let videoStr = item.video , let videoUrl = URL(string: videoStr) else {return}
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.backgroundColor = UIColor.black
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    
    private func configureImageStory(_ item: Stories) {
        self.videoView.isHidden = true
        self.imageView_iv.isHidden = false
        guard let imageStr = item.video, let imageUrl = URL(string: imageStr) else { return }
        self.imageView_iv.setImage(url: imageUrl)
    }
}
