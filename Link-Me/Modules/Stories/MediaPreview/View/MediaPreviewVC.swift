//
//  MediaPreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 12/09/2023.
//

import UIKit
import AVKit



class MediaPreviewVC: BaseWireFrame<MediaPreviewViewModel> {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var play_btn: UIButton!
    
    
    //MARK: - Properties
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    private var playButton: UIButton?

    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        player?.pause()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = self.videoView.bounds
    }
    
    //MARK: - Bind -
    
    override func bind(viewModel: MediaPreviewViewModel) {
        setupview()
    }
    
    //MARK: - Private Func -
    private func setupview(){
        
        
        switch viewModel.mediaType{
        case .image:
            imagePreview.isHidden = false
            videoView.isHidden = true
            play_btn.isHidden = true
            imagePreview.image = viewModel.image
            
        case .video:
            imagePreview.isHidden = true
            videoView.isHidden = false
            play_btn.isHidden = false
            videoView.backgroundColor = .white
            playVideo()
            
        }
    }
    
    
    private func playVideo(){
        guard let videoURl = viewModel.video else {return}
        player = AVPlayer(url: videoURl)
        playerLayer = AVPlayerLayer(player: player)
        videoView.backgroundColor = UIColor.black
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Create and configure the play button
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        let buttonX = videoView.center.x - 100 / 2
        let buttonY = videoView.center.y - 100 / 2
        button.frame = CGRect(x: buttonX, y: buttonY, width: 100, height: 100)
        button.tintColor = .white
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        
        
        self.videoView.layer.addSublayer(playerLayer!)
        self.videoView.addSubview(button)

    }
    
    @objc func buttonTapped() {
        play_btn.isHidden = true
        player?.play()
    }
    
    
    //MARK: - Actions -
    
    @IBAction func sendTapped(_ sender: Any) {
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
    }
}
