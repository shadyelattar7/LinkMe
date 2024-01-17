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
    
    // MARK: Proprites
    
    private var type: HeaderViewType = .acceptOrIgnoreAddRequest {
        didSet {
            configureHeaderViewType()
        }
    }
    
    private var onClick: () -> Void = { }
    
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
    
    // MARK: Actions
    
    @IBAction private func didTappedOnBackButton(_ sender: Any) {
        onClick()
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
        ignoreTextLabel.text = "\(name) ignore your"
    }
    
    func onClickBackButton(_ onClick: @escaping () -> Void) {
        self.onClick = onClick
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
