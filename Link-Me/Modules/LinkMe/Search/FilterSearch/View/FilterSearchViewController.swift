//
//  FilterSearchViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

enum GenderType: String {
    case male = "male"
    case female = "female"
}

class FilterSearchViewController: BaseWireFrame<FilterSearchViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var exitButton: UIButton!
    @IBOutlet private weak var diamondView: UIView!
    @IBOutlet private weak var countOfDiamondLabel: UILabel!
    @IBOutlet private weak var buyMoreButton: UIButton!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var ageView: AgeView!
    @IBOutlet private weak var maleView: UIView!
    @IBOutlet private weak var maleTitleLabel: UILabel!
    @IBOutlet private weak var maleImageView: UIImageView!
    @IBOutlet private weak var femaleView: UIView!
    @IBOutlet private weak var femaleTitleLabel: UILabel!
    @IBOutlet private weak var femaleImageView: UIImageView!
    @IBOutlet private weak var activeButton: UIButton!
    
    // MARK: Properties
    
    private var age: Int?
    private let picker = UIImagePickerController()
    private let countryPicker = UIPickerView()
    private var countryID: Int?
    private var gender: GenderType?
    
    // MARK: LifeCycle
    
    override func bind(viewModel: FilterSearchViewModel) {
        configureUI()
        configureAgeView()
        createPickerView()
        subscribeToErrorMessage()
        configureActiveButtonTitle()
        addActionToActiveButton()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedOnMaleViewButton(_ sender: Any) {
        selectMale()
    }
    
    @IBAction private func didTappedOnFemaleViewButton(_ sender: Any) {
        selectFemale()
    }
}

// MARK: - Private handlers

extension FilterSearchViewController {
    private func configureUI() {
        exitButton.layer.cornerRadius = 12
        exitButton.centerTextAndImage(spacing: -4)
        diamondView.layer.cornerRadius = 10
        buyMoreButton.layer.cornerRadius = 16
        activeButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .mainColor, textColor: .white)
    }
    
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObserver.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
}

// MARK: Configure age view

extension FilterSearchViewController {
    private func configureAgeView() {
        ageView.onSelected = { [weak self] item in
            guard let self = self else { return }
            self.age = item
        }
    }
}


//MARK: - Configure country field

extension FilterSearchViewController: UITextFieldDelegate {
    private func configureCountryTextField() {
        countryTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == countryTextField {
            self.countryPicker.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(countryPicker, didSelectRow: 0, inComponent: 0)
        }
    }
}

// MARK: - Configure picker view

extension FilterSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfCountries
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "lang".localized == "en" ? viewModel.countries.value[row].country_enName : viewModel.countries.value[row].country_arName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = "lang".localized == "en" ? viewModel.countries.value[row].country_enName : viewModel.countries.value[row].country_arName
        countryID = viewModel.countries.value[row].id ?? 0
    }
    
    func createPickerView(){
        countryPicker.delegate = self
        countryTextField.inputView = countryPicker
    }
}

// MARK: Configure gender view

extension FilterSearchViewController {
    private func selectMale() {
        maleView.backgroundColor = .LinkMeUIColor.lightPurple
        maleTitleLabel.textColor = .LinkMeUIColor.mainColor
        maleImageView.image = UIImage(named: "gender 2")
        
        gender = .male
        
        femaleView.backgroundColor = .LinkMeUIColor.lightGray
        femaleTitleLabel.textColor = .LinkMeUIColor.strongGray
        femaleImageView.image = UIImage(named: "gender 1")
        
    }
    
    private func selectFemale() {
        femaleView.backgroundColor = .LinkMeUIColor.lightPurple
        femaleTitleLabel.textColor = .LinkMeUIColor.mainColor
        femaleImageView.image = UIImage(named: "gender 3")
        
        gender = .female
        
        maleView.backgroundColor = .LinkMeUIColor.lightGray
        maleTitleLabel.textColor = .LinkMeUIColor.strongGray
        maleImageView.image = UIImage(named: "gender")
    }
}

// MARK: Configure Active button

extension FilterSearchViewController {
    private func configureActiveButtonTitle() {
        // TODO: Need flag to handle title of button ["Buy Diamonds" or "Start Searching"].
        
        self.activeButton.setTitle("Start Searching", for: .normal)
    }
    
    private func addActionToActiveButton() {
        activeButton.addTarget(self, action: #selector(didTappedOnActiveButton), for: .touchUpInside)
    }
    
    @objc private func didTappedOnActiveButton() {
        // TODO: Need flag to handle action of button [go to market or Start Searching].
        
        let model = SearchRequestModel(gander: self.gender?.rawValue, timePeriod: self.age, countryID: self.countryID)
        let vc = coordinator.Main.viewcontroller(for: .searchingForUsers(requestModel: model))
        self.present(vc, animated: true)
    }
}
