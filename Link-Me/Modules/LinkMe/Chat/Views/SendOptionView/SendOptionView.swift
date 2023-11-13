//
//  SendOptionView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 13/11/2023.
//

import UIKit


class SendOptionView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var microphoneButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    
    // MARK: Proprites
    
    private var onChange: ((String)->()) = { _ in }
    private var onClickCamera: (()->()) = { }
    private var onClickMic: (()->()) = { }
    private var onClickAdd: (()->()) = { }
    
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
        configureTextFieldObserver()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTappedOnAddButton(_ sender: Any) {
        onClickAdd()
    }
    
    @IBAction private func didTappedOnMicrophoneButton(_ sender: Any) {
        onClickMic()
    }
    
    @IBAction private func didTappedOnCameraButton(_ sender: Any) {
        onClickCamera()
    }
}

// MARK: - Usage Functions

extension SendOptionView {
    func onChange(_ onChange: @escaping (String) -> Void) {
        self.onChange = onChange
    }
    
    func onClickCamera(_ onClick: @escaping () -> Void) {
        onClickCamera = onClick
    }
    
    func onClickMic(_ onClick: @escaping () -> Void) {
        onClickMic = onClick
    }
    
    func onClickAdd(_ onClick: @escaping () -> Void) {
        onClickAdd = onClick
    }
}

// MARK: Private handlers

extension SendOptionView {
    private func configureUI() {
        containerView.layer.cornerRadius = 12
        cameraButton.makeCircleView()
        microphoneButton.makeCircleView()
    }
    
    private func configureTextFieldObserver() {
        inputTextField.addTarget(self, action: #selector(textEditingChanged), for: .editingChanged)
    }

    @objc private func textEditingChanged() {
        onChange(self.inputTextField.text ?? "")
    }
}


