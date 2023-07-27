//
//  DeleteAccountVC.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import UIKit

class DeleteAccountVC: BaseWireFrame<DeleteAccountViewModel> {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var password_tf: InputView!
    @IBOutlet weak var confirmDeletion_btn: MainButton!
    @IBOutlet weak var cancel_btn: UIButton!
    
    //MARK: - Variables -
    
    
    //MARK: - Bind -
    
    override func bind(viewModel: DeleteAccountViewModel) {
        setupView()
        subscriptions()
    }
    
    
    //MARK: - Private func -
    
    private func setupView(){
        confirmDeletion_btn.MainBtn.addTarget(self, action: #selector(confirmDeletionTapped), for: .touchUpInside)
    }
    
    private func subscriptions(){
        viewModel.DeleteAccountStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        UserDefaults.standard.removeObject(forKey: UDKeys.token)
                        self.coordinator.start()
                    }
                }
                
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
        
    }
    
    
    //MARK: - Actions -
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func confirmDeletionTapped(){
        guard password_tf.validate(for: .required(localizedFieldName: "")) else {return}
        viewModel.deleteAccount(password: password_tf.text, view: self.view)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
