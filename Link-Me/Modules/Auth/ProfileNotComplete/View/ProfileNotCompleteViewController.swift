//
//  ProfileNotCompleteViewController.swift
//  Link-Me
//
//  Created by Al-attar on 05/06/2023.
//

import UIKit

class ProfileNotCompleteViewController: BaseWireFrame<ProfileNotCompleteViewModel> {

    //MARK: - @IBOutlet
    
    @IBOutlet weak var completeProfile_btn: MainButton!
    @IBOutlet weak var profileImgView: UserPhotoProfileView!

    
    //MARK: - Variables
    
    //MARK: - Bind
    
    override func bind(viewModel: ProfileNotCompleteViewModel) {
        setupView()
    }

    //MARK: - Private func
    
    private func setupView(){
        profileImgView.configure(with: UserPhotoProfileViewViewModel(userPhoto: UDHelper.fetchUserData?.imagePath ?? "", precntage: 25, radiusCircular: 45), precntage: .quarter)
        
        completeProfile_btn.MainBtn.addTarget(self, action: #selector(completeProfileTapped), for: .touchUpInside)
    }
    
    //MARK: - Actions
    
    @objc func completeProfileTapped(){
        UDHelper.isCompleteProfile = true
        UDHelper.isAfterLoginOrRegister = true
     //   self.coordinator.start()
        if let vc = coordinator.Main.viewcontroller(for: .CompleteProfile(fromAuth: true)) as? CompleteProfileVC {
               present(vc, animated: true)
           }
    }
    
    
    @IBAction func laterTapped(_ sender: Any) {
        UDHelper.isCompleteProfile = false
        self.coordinator.start()
    }
}
