//
//  EditProfileVC.swift
//  Link-Me
//
//  Created by Al-attar on 19/06/2023.
//

import UIKit


class EditProfileVC: BaseWireFrame<EditProfileViewModel>, NavigationBarDelegate {
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var userImg_iv: UIImageView!
    @IBOutlet weak var pickImage: UIButton!
    @IBOutlet weak var yourName_TF: InputView!
    @IBOutlet weak var yourUsername_TF: InputView!
    @IBOutlet weak var yourAge_TF: InputView!
    @IBOutlet weak var yourCountry_TF: UITextField!
    
    @IBOutlet weak var maleTitle_lbl: UILabel!
    @IBOutlet weak var maleIcon_iv: UIImageView!
    @IBOutlet weak var maleView: UIView!
    
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleIcon_iv: UIImageView!
    @IBOutlet weak var femaleTitle_lbl: UILabel!
    
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bio_TV: UITextView!
    @IBOutlet weak var save_btn: MainButton!
    
    
    //MARK: - Variables
    private var profileImage = UIImage()
    private let picker = UIImagePickerController()
    let countryPicker = UIPickerView()
    var countryID: Int = 0
    var gender: String = ""
    
    
    //MARK: - Bind
    
    override func bind(viewModel: EditProfileViewModel) {
        viewModel.ViewDidLoad(view: self.view)
        setupView()
        setupUserData()
        creatPickerView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        picker.delegate = self
        yourCountry_TF.delegate = self
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Edit Profile".localized), and: self)
        save_btn.MainBtn.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
    }
    
    private func subscriptions(){
        viewModel.EditProfileStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setupUserData(){
       
        let userData = UDHelper.fetchUserData
       
        
        userImg_iv.getImage(imageUrl: userData?.imagePath ?? "")
        
        let image = userImg_iv.image!.jpegData(compressionQuality: 0.6)! as Data
        viewModel.userImg.accept(image)
        viewModel.logoMimeType.accept("image/jpeg")
       

        yourName_TF.text = userData?.name ?? ""
        yourUsername_TF.text = userData?.user_name ?? ""
        yourAge_TF.text = userData?.birth_date ?? ""
        yourCountry_TF.text = userData?.country ?? ""
        countryID = userData?.country_id ?? 0
        
        if userData?.gander == "male"{
            selectMale()
        }else{
            selectFamale()
        }
        
        bio_TV.text = userData?.bio ?? ""
        
    }
    
    private func selectMale(){
        maleView.backgroundColor = .LinkMeUIColor.lightPurple
        maleTitle_lbl.textColor = .LinkMeUIColor.mainColor
        maleIcon_iv.image = UIImage(named: "gender 2")
        
        gender = "male"
        
        femaleView.backgroundColor = .LinkMeUIColor.lightGray
        femaleTitle_lbl.textColor = .LinkMeUIColor.strongGray
        femaleIcon_iv.image = UIImage(named: "gender 1")
        
    }
    
    private func selectFamale(){
        
        femaleView.backgroundColor = .LinkMeUIColor.lightPurple
        femaleTitle_lbl.textColor = .LinkMeUIColor.mainColor
        femaleIcon_iv.image = UIImage(named: "gender 3")
        
        gender = "female"
        
        
        maleView.backgroundColor = .LinkMeUIColor.lightGray
        maleTitle_lbl.textColor = .LinkMeUIColor.strongGray
        maleIcon_iv.image = UIImage(named: "gender")
    }
    
    
    private func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    //MARK: - Actions
    
   func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveChangesTapped(){
       viewModel.editProfile(email: UDHelper.fetchUserData?.email ?? "", name: yourName_TF.text, username: yourUsername_TF.text , birth_date: yourAge_TF.text , country_id: "\(countryID)", gander: gender , bio: bio_TV.text ?? "", view: self.view)
    }
    
    @IBAction func maleTapped(_ sender: Any) {
        selectMale()
    }
    
    @IBAction func femaleTapped(_ sender: Any) {
        selectFamale()
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

extension EditProfileVC: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
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


//MARK: - Picker View Configuration

extension EditProfileVC: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return viewModel.numberOfCountries
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "lang".localized == "en" ? viewModel.Countries.value[row].country_enName : viewModel.Countries.value[row].country_arName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yourCountry_TF.text = "lang".localized == "en" ? viewModel.Countries.value[row].country_enName : viewModel.Countries.value[row].country_arName
        countryID = viewModel.Countries.value[row].id ?? 0
    }
    
    func creatPickerView(){
        countryPicker.delegate = self
        yourCountry_TF.inputView = countryPicker
    }
    
    
}

//MARK: - UITextField Delegate

extension EditProfileVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == yourCountry_TF{
            self.countryPicker.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(countryPicker, didSelectRow: 0, inComponent: 0)
        }
    }
}
