//
//  RemoveAccountVC.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import UIKit
import UITextView_Placeholder

class RemoveAccountVC: BaseWireFrame<RemoveAccountViewModel>, NavigationBarDelegate {
   
    //MARK: - @IBOutlet -
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var reason_tv: UITextView!
    @IBOutlet weak var save_btn: MainButton!
    
    //MARK: - Bind -
   
    override func bind(viewModel: RemoveAccountViewModel) {
        setupView()
    }
    
    //MARK: - Private func -
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Remove Account"), and: self)
        save_btn.MainBtn.addTarget(self, action: #selector(ContinueTapped), for: .touchUpInside)
        reason_tv.placeholder = "Your Explanation Is Entirely Optional..."
    }

    //MARK: - Actions -
 
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
    
    @objc func ContinueTapped(){
        self.coordinator.Main.navigate(for: .DeleteAccount(reason: reason_tv.text ?? viewModel.reason),navigtorTypes: .present(style: .overFullScreen))
    }
}
