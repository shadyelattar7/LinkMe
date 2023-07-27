//
//  SendEmailVC.swift
//  Link-Me
//
//  Created by Al-attar on 29/06/2023.
//

import UIKit

//1
protocol SendEmailDismissed: AnyObject {
    func checkIsDismissed(isDismiss: Bool)
}


class SendEmailVC: BaseWireFrame<SendEmailViewModel> {

    //MARK: - @IBOutlet -
    
    @IBOutlet weak var userImage_iv: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var email_tf: InputView!
    @IBOutlet weak var subject_tf: InputView!
    @IBOutlet weak var descripation_tv: UITextView!
    @IBOutlet weak var save_btn: MainButton!
    
    //MARK: - Variables -
 
    
    //2
    weak var delegate: SendEmailDismissed!
    
    //MARK: - Bind -
    
    override func bind(viewModel: SendEmailViewModel) {
        setupView()
        subscriptions()
    }

    //MARK: - Private func -
    
    private func setupView(){
        descripation_tv.placeholder = "How We Can Help You!"
        save_btn.MainBtn.addTarget(self, action: #selector(SendTapped), for: .touchUpInside)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
          view.addGestureRecognizer(panGesture)

    }
    
    private func subscriptions(){
        viewModel.sendEmailStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        self.delegate.checkIsDismissed(isDismiss: true)
                    }
                }
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
    
    }
    
    
    //MARK: - Actions -
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            // Update the modal view controller's frame based on the vertical translation
            view.frame.origin.y = max(translation.y, 0)
        } else if gesture.state == .ended {
            let screenHeight = UIScreen.main.bounds.height
            
            if translation.y > screenHeight * 0.3 {
                // Dismiss the modal view controller
                dismiss(animated: true, completion: nil)
            } else {
                // Reset the modal view controller's frame
                UIView.animate(withDuration: 0.5) {
                    self.view.frame.origin.y = 0
                }
            }
        }
    }


    @objc func SendTapped(){
        guard email_tf.validate(for: .email) else {return}
        self.viewModel.sendEmail(email: email_tf.text, title: subject_tf.text, description: descripation_tv.text, view: self.view)
    }
}
