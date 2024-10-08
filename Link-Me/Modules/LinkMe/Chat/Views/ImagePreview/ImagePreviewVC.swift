//
//  ImagePreviewVC.swift
//  Link-Me
//
//  Created by Al-attar on 17/09/2024.
//

import UIKit
import AVKit

class ImagePreviewVC: BaseWireFrame<ChatViewModel> {

    //MARK: - @IBOutlet -
    
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var send_btn: UIButton!
    @IBOutlet weak var play_btn: UIButton!
    @IBOutlet weak var oneTimeBtn: UIButton!
    
    //MARK: - Properties
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    private var playButton: UIButton?
    private var isOneTimeEnabled = false


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
    
    override func bind(viewModel: ChatViewModel) {
        setupView()
    }
    
    //MARK: - Private Func -
    private func setupView() {
        let isSendMode = viewModel.mediaPreviewType == .send
        configureButtons(isSendMode: isSendMode)
        
        switch viewModel.mediaType {
        case .image:
            setupImageView(isSendMode: isSendMode)
        case .video:
            setupVideoView(isSendMode: isSendMode)
        }
    }

    private func configureButtons(isSendMode: Bool) {
        oneTimeBtn.isHidden = !isSendMode
        send_btn.isHidden = !isSendMode
    }

    private func setupImageView(isSendMode: Bool) {
        imagePreview.isHidden = false
        videoView.isHidden = true
        play_btn.isHidden = true
        
        if isSendMode {
            imagePreview.image = viewModel.selectedImageRelay.value
        } else {
            if let previewUrl = URL(string: viewModel.mediaToPreview) {
                imagePreview.setImage(url: previewUrl)
            }
        }
    }

    private func setupVideoView(isSendMode: Bool) {
        imagePreview.isHidden = true
        videoView.isHidden = false
//        play_btn.isHidden = false
        videoView.backgroundColor = .white
        playVideo(isSendMode: isSendMode)
    }

    private func playVideo(isSendMode: Bool){
        // Select the correct URL based on isSendMode
        let videoURL: URL?
        
        if isSendMode {
            videoURL = viewModel.video // Assuming video is of type URL?
        } else {
            videoURL = URL(string: viewModel.mediaToPreview)  // Assuming mediaToPreview is of type URL?
        }
        
        // Safely unwrap the selected video URL
        guard let validVideoURL = videoURL else {
            print("Invalid video URL.")
            return
        }
        print("validVideoURL: \(validVideoURL)")
        player = AVPlayer(url: validVideoURL)
        playerLayer = AVPlayerLayer(player: player)
        videoView.backgroundColor = UIColor.black
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer!)
        
        // Create and configure the play button
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        videoView.addSubview(button)
        
        // Set Auto Layout constraints for centering the button
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    
    @objc func buttonTapped() {
        play_btn.isHidden = true
        player?.play()
    }
    
    
    //MARK: - Actions -
    
    @IBAction func sendImageTapped(_ sender: Any) {
        
        switch viewModel.mediaType {
        case .image:
            let imageData = self.viewModel.selectedImageRelay.value?.jpegData(compressionQuality: 0.3)
            self.viewModel.updateMediaData(imageData)
            self.viewModel.updateMessageType(.file)
            self.viewModel.updateMediaMessageType(.image)
            self.viewModel.sendMessage { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed to upload image")
                }
            }
        case .video:
            guard let videoData = self.viewModel.video else { return }
            self.viewModel.updateVideo(videoData)
            self.viewModel.updateMessageType(.file)
            self.viewModel.updateMediaMessageType(.video)
            self.viewModel.sendMessage { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed to upload video")
                }
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playTapped(_ sender: Any) {
        
    }
    
    @IBAction func setTOViewOnceTapped(_ sender: Any) {
        isOneTimeEnabled.toggle()
        
        if isOneTimeEnabled {
            oneTimeBtn.backgroundColor = UIColor.LinkMeUIColor.mainColor
            self.viewModel.oneTime("1")
        } else {
            oneTimeBtn.backgroundColor = UIColor.white
            self.viewModel.oneTime("0")
        }
    }
}

