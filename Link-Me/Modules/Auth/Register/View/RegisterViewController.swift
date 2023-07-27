//
//  RegisterViewController.swift
//  Link-Me
//
//  Created by Al-attar on 15/05/2023.
//

import UIKit
import BEMCheckBox

class RegisterViewController: BaseWireFrame<RegisterViewModel>, BEMCheckBoxDelegate, NavigationBarDelegate {
 
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var userImg_iv: UIImageView!
    @IBOutlet weak var pickPhoto_btn: UIButton!
    @IBOutlet weak var name_tf: InputView!
    @IBOutlet weak var age_tf: InputView!
    @IBOutlet weak var password_tf: InputView!
    @IBOutlet weak var confirmPassword_tf: InputView!
    @IBOutlet weak var done_btn: MainButton!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    //MARK: - Variables
    
    private var profileImage = UIImage()
    private let picker = UIImagePickerController()
    


    //MARK: - Bind
    
    override func bind(viewModel: RegisterViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        checkBox.delegate = self
        picker.delegate = self
        checkBox.boxType = .square
        navBar.configure(with: NavigationBarViewModel(navBarTitle: ""), and: self)
        done_btn.MainBtn.isUserInteractionEnabled = false
        done_btn.MainBtn.backgroundColor = .LinkMeUIColor.lightPurple
        done_btn.MainBtn.addTarget(self, action: #selector(register), for: .touchUpInside)

    }
    
    private func subscriptions(){
        viewModel.RegisterStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                self.coordinator.Auth.navigate(for: .ProfileNotComplete)
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }

    
   private func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    //MARK: - Actions
    
    func didTap(_ checkBox: BEMCheckBox) {
        print(checkBox.on)
        if checkBox.on{
            done_btn.MainBtn.isUserInteractionEnabled = true
            done_btn.MainBtn.backgroundColor = .LinkMeUIColor.mainColor
        }else{
            done_btn.MainBtn.isUserInteractionEnabled = false
            done_btn.MainBtn.backgroundColor = .LinkMeUIColor.lightPurple
        }
    }
    
    func backButtonPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func register(){
        guard name_tf.validate(for: .required(localizedFieldName: "")) else {return}
        guard password_tf.validate(for: .required(localizedFieldName: "")) else {return}
        guard confirmPassword_tf.validate(for: .confirmPassword(password: password_tf.text)) else {return}

        viewModel.register(name: name_tf.text, password: password_tf.text, birth_date: age_tf.text,view: self.view)
    }
    
    @IBAction func pickImgTapped(_ sender: Any) {
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
}


//MARK: - Image Picker Controller delegate

extension RegisterViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :     Any]) {
      
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let mimeType = url.mimeType()
            viewModel.logoMimeType.accept(mimeType)
        }
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.userImg_iv.contentMode = .scaleAspectFill
            self.profileImage = pickedImage
            self.userImg_iv.image = self.profileImage
            guard let userImage = pickedImage.jpegData(compressionQuality: 0.6) else {return}
            viewModel.userImg.accept(userImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

