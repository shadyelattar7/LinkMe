//
//  HeaderChatView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit

class HeaderChatView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var ignoreTextStackView: UIStackView!
    @IBOutlet private weak var ignoreTextLabel: UILabel!
    @IBOutlet weak var timerStackView: UIStackView!
    
    // MARK: Proprites
    private var countdownTimer: Timer?
    private var expiryDate: Date?
    
    private var type: HeaderViewType = .acceptOrIgnoreAddRequest {
        didSet {
            configureHeaderViewType()
        }
    }
    
    private var onClickBackButtonClosure: () -> Void = { }
    private var onFirstButtonActionClosure: (() -> Void)?
    private var onSecondButtonActionClosure: (() -> Void)?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        loadViewFromNib()
        configureUI()
        configureHeaderViewType()
    }
    
    deinit {
        countdownTimer?.invalidate()
    }
    
    // MARK: Actions
    
    @IBAction func didTappedOnFirstButton(_ sender: Any) {
        onFirstButtonActionClosure?()
    }
    
    @IBAction func didTappedOnSecondButton(_ sender: Any) {
        onSecondButtonActionClosure?()
    }
    
    @IBAction private func didTappedOnBackButton(_ sender: Any) {
        onClickBackButtonClosure()
    }
}

// MARK: Usage functions

extension HeaderChatView {
    func setType(_ type: HeaderViewType) {
        self.type = type
    }
    
    func setUserImage(image: UIImage) {
        userImageView.image = image
    }
    
    func setUserImage(imagePath: String) {
        guard let imageUrl = URL(string: imagePath) else { return }
        userImageView.setImage(url: imageUrl)
    }
    
    func setOtherPersonName(_ name: String) {
        ignoreTextLabel.text = "\(name)" + "ignore your".localized
    }
    
    func onClickBackButton(_ onClick: @escaping () -> Void) {
        self.onClickBackButtonClosure = onClick
    }
    
    func onFirstButtonAction(_ action: @escaping () -> Void) {
        self.onFirstButtonActionClosure = action
    }
    
    func onSecondButtonAction(_ action: @escaping () -> Void) {
        self.onSecondButtonActionClosure = action
    }
}


// MARK: Private handlers

extension HeaderChatView {
    private func configureUI() {
        userImageView.makeCircleView()
    }
    
    private func configureHeaderViewType() {
        ignoreTextStackView.isHidden = type.isHiddenIgnoreMessage
        firstButton.isHidden = type.isHiddenFirstButton
        firstButton.setHeaderChatButtonAttributes(title: type.firstButtonType?.buttonTitle,
                                                  image: type.firstButtonType?.buttonImage,
                                                  backgroundColor: type.firstButtonType?.buttonBackgroundColor,
                                                  textColor: type.firstButtonType?.buttonTextColor,
                                                  borderColor: type.firstButtonType?.buttonBorderColor,
                                                  borderWidth: type.firstButtonType?.buttonBorderWidth)
        
        secondButton.setHeaderChatButtonAttributes(title: type.secondButtonType?.buttonTitle,
                                                   image: type.secondButtonType?.buttonImage,
                                                   backgroundColor: type.secondButtonType?.buttonBackgroundColor,
                                                   textColor: type.secondButtonType?.buttonTextColor,
                                                   borderColor: type.secondButtonType?.buttonBorderColor,
                                                   borderWidth: type.secondButtonType?.buttonBorderWidth)
    }
}


extension UIButton {
    func setHeaderChatButtonAttributes(title: String?,
                                       image: UIImage?,
                                       backgroundColor: UIColor?,
                                       textColor: UIColor?,
                                       borderColor: UIColor?,
                                       borderWidth: CGFloat?) {
        
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth ?? 0.0
        self.layer.cornerRadius = 18
        self.centerTextAndImage(spacing: -6)
        self.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
    }
}

// MARK: Countdown Logic
extension HeaderChatView {
    
//    func startCountdown(minutesFromNow: Int) {
//        // Calculate the future timestamp
//        let futureDate = Date().addingTimeInterval(TimeInterval(minutesFromNow * 60))
//        let expireTimestamp = futureDate.timeIntervalSince1970 * 1000 // Convert to milliseconds
//        
//        // Convert the timestamp to string
//        let expireTimestampString = String(expireTimestamp)
//        
//        // Start countdown with the calculated timestamp
//        startCountdown(expireTimestampString: expireTimestampString)
//    }
    
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
            timerLabel.text = "00 min 00 sec".localized
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
