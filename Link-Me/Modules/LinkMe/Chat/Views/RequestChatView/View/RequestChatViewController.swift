//
//  RequestChatViewController.swift
//  Link-Me
//
//  Created by Al-attar on 05/10/2024.
//

import UIKit

class RequestChatViewController: BaseWireFrame<RequestChatViewModel> {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: Proprites
    private var countdownTimer: Timer?
    private var expiryDate: Date?
    
    override func bind(viewModel: RequestChatViewModel) {
        subscriptionAcceptChat()
        subscriptionRefuseChat()
    }
    
    
    private func subscriptionAcceptChat() {
        viewModel.acceptChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            print("subscriptionAcceptChat: 🟢")
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionRefuseChat() {
        viewModel.refuseChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            print("subscriptionAcceptChat: 🛑")
            
        }.disposed(by: disposeBag)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        self.viewModel.acceptChatRequest()
    }
    
    @IBAction func ignoreTapped(_ sender: Any) {
        self.viewModel.refuseChatRequest()
    }
}

// MARK: Countdown Logic
extension RequestChatViewController {
    
    func startCountdown(expireAt: String) {
        // Convert the string to a TimeInterval
        guard let expireTimestamp = TimeInterval(expireAt) else {
            print("Invalid timestamp format")
            return
        }
        
        // Convert the timestamp to Date
        expiryDate = Date(timeIntervalSince1970: expireTimestamp / 1000)
        
        print("expiryDate: \(expiryDate)")
        
        // Invalidate any existing timer
        countdownTimer?.invalidate()
        
        // Start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        
        // Initial update
        updateCountdown()
    }
    
    @objc private func updateCountdown() {
        guard let expiryDate = expiryDate else { return }
        
        let remainingTime = expiryDate.timeIntervalSinceNow
        
        if remainingTime <= 0 {
            countdownTimer?.invalidate()
            timerLabel.text = "00 min 00 sec"
            timerEnded()
        } else {
            let minutes = Int(remainingTime) % 3600 / 60
            let seconds = Int(remainingTime) % 60
            timerLabel.text = String(format: "%02d min %02d sec", minutes, seconds)
        }
    }
    
    private func timerEnded() {
        print("Time End ⌛️🔚")
        // Handle when the countdown ends
        // You can trigger any additional actions needed when the timer ends
    }
}
