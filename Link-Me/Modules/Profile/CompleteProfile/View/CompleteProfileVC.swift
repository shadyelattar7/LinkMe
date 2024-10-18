//
//  CompleteProfileVC.swift
//  Link-Me
//
//  Created by Al-attar on 16/06/2023.
//

import UIKit
import UITextView_Placeholder
import RxSwift

class CompleteProfileVC: BaseWireFrame<CompleteProfileViewModel> {
    
    
    //MARK: - @IBOutlet
    @IBOutlet weak var userImage_iv: UserPhotoProfileView!
    @IBOutlet weak var country_TF: UITextField!
    @IBOutlet weak var setFullHeight: NSLayoutConstraint!
    @IBOutlet weak var male_Btn: UIButton!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleIcon_iv: UIImageView!
    @IBOutlet weak var male_lbl: UILabel!
    @IBOutlet weak var frmale_Btn: UIButton!
    @IBOutlet weak var famaleView: UIView!
    @IBOutlet weak var famaleIcon_iv: UIImageView!
    @IBOutlet weak var famale_lbl: UILabel!
    @IBOutlet weak var bio_TV: UITextView!
    @IBOutlet weak var save_btn: MainButton!
    var reloadAfterDismiss: ReloadAfterDismiss?
    
    //MARK: - Variables
    let countryPicker = UIPickerView()
    var countryID: Int = 0
    var gender: String = ""
    
    
    //MARK: - Bind
    
    override func bind(viewModel: CompleteProfileViewModel) {
        setupView()
        subscriptions()
        viewModel.dismissSubject.observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] dismiss in
                        guard let self = self else { return }
                        if dismiss {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.dismiss(animated: true, completion: nil)
                            }
                            self.reloadAfterDismiss?.reloadAfter()
                        }
                    }).disposed(by: disposeBag)
    }
    //MARK: - Private func
    
    private func setupView(){
        viewModel.ViewDidLoad(view: self.view)
        
        userImage_iv.configure(with: UserPhotoProfileViewViewModel(userPhoto: UDHelper.fetchUserData?.imagePath ?? "", precntage: 50, radiusCircular: 45), precntage: .half)
        
        bio_TV.placeholder = "Tell Something About You".localized
        
        country_TF.delegate = self
        creatPickerView()
        
        save_btn.MainBtn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
    }
    
    private func subscriptions(){
        viewModel.completeProfileStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                ToastManager.shared.showToast(message: "Success complete profile", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    private func selectMale(){
        maleView.backgroundColor = .LinkMeUIColor.lightPurple
        male_lbl.textColor = .LinkMeUIColor.mainColor
        maleIcon_iv.image = UIImage(named: "gender 2")
    
        gender = "male"
    
        famaleView.backgroundColor = .LinkMeUIColor.lightGray
        famale_lbl.textColor = .LinkMeUIColor.strongGray
        famaleIcon_iv.image = UIImage(named: "gender 1")
        
    }
    
    private func selectFamale(){
        
        famaleView.backgroundColor = .LinkMeUIColor.lightPurple
        famale_lbl.textColor = .LinkMeUIColor.mainColor
        famaleIcon_iv.image = UIImage(named: "gender 3")
        
        gender = "female"

        
        maleView.backgroundColor = .LinkMeUIColor.lightGray
        male_lbl.textColor = .LinkMeUIColor.strongGray
        maleIcon_iv.image = UIImage(named: "gender")
    }
    
    private func enableBtn(){
        save_btn.MainBtn.backgroundColor = .LinkMeUIColor.mainColor
        save_btn.MainBtn.isEnabled = true
    }

    private func disableBtn(){
        save_btn.MainBtn.backgroundColor = .LinkMeUIColor.lightPurple
        save_btn.MainBtn.isEnabled = false
    }
    
    
    
    //MARK: - Actions
    
    @objc func saveTapped() {
        viewModel.completeProfile(country_id: countryID, bio: bio_TV.text, gander: gender, view: self.view) {  success in
            if success {
                if self.viewModel.fromAuth {
                    UDHelper.isCompleteProfile = false
                    self.coordinator.start()
                }
            }
        }
    }
    
    @IBAction func maleTapped(_ sender: Any) {
        selectMale()
    }
    
    @IBAction func famelaTapped(_ sender: Any) {
        selectFamale()
    }
}

//MARK: - Picker View Configuration

extension CompleteProfileVC: UIPickerViewDelegate,UIPickerViewDataSource{
    
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
        country_TF.text = "lang".localized == "en" ? viewModel.Countries.value[row].country_enName : viewModel.Countries.value[row].country_arName
        countryID = viewModel.Countries.value[row].id ?? 0
    }
    
    func creatPickerView (){
        countryPicker.delegate = self
        country_TF.inputView = countryPicker
    }
    
    
}

//MARK: - UITextField Delegate

extension CompleteProfileVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == country_TF{
            self.countryPicker.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(countryPicker, didSelectRow: 0, inComponent: 0)
        }
    }
}
