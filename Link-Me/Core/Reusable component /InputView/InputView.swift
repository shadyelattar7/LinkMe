//
//  InputView.swift
//  toucherPackage
//
//  Created by LapStore on 04/04/2022.
//

import Foundation
import UIKit
import CountryPicker
import IQKeyboardManagerSwift

protocol TrailingButtonProtocal{
    func TrailingButtonAction(sender: InputView)

}

class InputView : NibLoadingView {
    
    // MARK: -  Outs
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var openCountryCode: UIButton!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var containerOfCountryCode: UIView!
    @IBOutlet weak var hiehtOfContainerTextField: NSLayoutConstraint!
    @IBOutlet weak var requiredFiledLbl: UILabel!
    @IBOutlet weak var inputFieldTf: UITextField!
    @IBOutlet weak var titelLbl: UILabel!
    @IBOutlet weak var containerOfTextFieldWithLbl: UIView!
    @IBOutlet weak var trailingButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel! {
        didSet{
            errorMessageLabel.text = "This data is required.".localized
        }
    }
    // MARK: -  Properties
    var hasTrailingImage: Bool = false
    var datePicker = UIDatePicker()
    var trailingButtonDeleget : TrailingButtonProtocal?
    var trailingButtonPress: () ->() = {}
    
    lazy private var picker = CountryPickerViewController()
    var selectedCode  = "+965"
    
    var containerOfTextFieldborderColor: UIColor = .black.withAlphaComponent(0.05)
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(view)
        requiredFiledLbl.isHidden = true
        containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
        containerOfTextFieldWithLbl.roundCorners(radius: 10)
       // titelLbl.isHidden = true
        inputFieldTf.addTarget(self, action: #selector(showTitel), for: .editingChanged)
        self.superview?.backgroundColor = .clear
        
    }
    
    @IBInspectable var trailingButtonImage: UIImage {
        get {
            trailingButton.imageView?.image ?? UIImage()
        }
        set {
            trailingButton.setImage(newValue,
                                    for: .normal)
            trailingButton.isHidden = false
        }
    }
    
    @IBInspectable var trailingButtonTitle: String {
        get {
            trailingButton.currentTitle ?? ""
        }
        set {
            trailingButton.setImage(nil, for: .normal)
            trailingButton.setTitle(newValue, for: .normal)
            trailingButton.isHidden = false
        }
    }
    
    @IBInspectable var showShadow: Bool = false {
        didSet {
            if showShadow {
                containerOfTextFieldWithLbl.addShadow(color: .black, alpha: 0.07, xValue: 0, yValue: 0, blur: 1)
            }
        }
    }
    
    @IBInspectable var disableRequireText: Bool = false
    @IBInspectable var maximumDate: Bool = false

    
    @IBInspectable var dateInput: Bool = false{
        didSet {
            if dateInput {
                setupdataInput(isDate: true)
            }
        }
    }
    
    @IBInspectable var hourInput: Bool = false {
        didSet {
            if hourInput {
                setupdataInput(isDate: false)
            }
        }
    }
    
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.placeholder = newValue.localized
        }
    }
    
    @IBInspectable var textTitle: String {
        get {
            titelLbl.text ?? ""
        }
        set {
            titelLbl.text = newValue.localized
        }
    }
    
    var textFont: UIFont? {
        get {
            inputFieldTf.font
        }
        set {
            inputFieldTf.font = newValue
        }

    }
    
    var titleFont: UIFont? {
        get {
            titelLbl.font
        }
        set {
            titelLbl.font = newValue
        }

    }

    @IBInspectable var bgColor: UIColor? {
        get {
            containerView.backgroundColor
        }
        set {
            containerView.backgroundColor = newValue
        }
    }

    @IBInspectable var textColor: UIColor? {
        get {
            titelLbl.textColor
        }
        set {
            titelLbl.textColor = newValue
        }
    }

    @IBInspectable var text: String {
        get {
            inputFieldTf.text ?? ""
        }
        set {
            inputFieldTf.text = newValue.localized
            if !(inputFieldTf.text?.isEmpty ?? true) {
                //titelLbl.isHidden = false
                ///hiehtOfContainerTextField.constant = 30
                containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
                requiredFiledLbl.isHidden = true
            }
        }
    }

    @IBInspectable var placeholder: String {
        get {
            inputFieldTf.placeholder ?? ""
        }
        set {
            inputFieldTf.placeholder = newValue.localized
        }
    }
    
    @IBInspectable var isEmailTextEntry: Bool = false {
        didSet {
            inputFieldTf.keyboardType = .emailAddress
        }
    }

    @IBInspectable var isSecureTextEntry: Bool = false {
        didSet {
            inputFieldTf.isSecureTextEntry = isSecureTextEntry
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.trailingButton.isHidden = !self.isSecureTextEntry
            }
            let image = isSecureTextEntry ? #imageLiteral(resourceName: "Show") : #imageLiteral(resourceName: "Show")
            trailingButton.setImage(image, for: .normal)
        }
    }
    
    @IBInspectable var isPhoneWithCountryCode: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.containerOfCountryCode.isHidden = !self.isPhoneWithCountryCode
                self.containerOfCountryCode.layoutIfNeeded()
                self.containerOfCountryCode.updateConstraints()
                self.inputFieldTf.keyboardType = .phonePad
                self.updateConstraints()
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(view)
        requiredFiledLbl.isHidden = true
        containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
        containerOfTextFieldWithLbl.roundCorners(radius: 10)
       // titelLbl.isHidden = true
        inputFieldTf.addTarget(self, action: #selector(showTitel), for: .editingChanged)
        inputFieldTf.delegate = self
    }
    // MARK: - check validate input data
    func validate(for type: ValidatorType) -> Bool {
        let validator = ValidatorResolver.validate( for: type)
        do {
            try validator.validate(text)
        } catch let error as ValidationError {
           showErrorText(errorText: error.message)
            return false
        } catch {
            return false
        }
        return true
    }
    
    @objc func showTitel(sender : UITextField){
        if sender.text?.isEmpty ?? false {
            showErrorText()
        }else{
           // titelLbl.isHidden = false
            //hiehtOfContainerTextField.constant = 30
            containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
            requiredFiledLbl.isHidden = true
        }
    }
    // MARK: - setup data Input
    func setupdataInput (isDate : Bool) {
        inputFieldTf.iq.toolbar.doneBarButton.setTarget(self, action: #selector(getDate))
        datePicker.datePickerMode = isDate ? .date : .time
        datePicker.preferredDatePickerStyle = .wheels
        inputFieldTf.inputView = datePicker
    }
    
    // MARK: - get Date from data picker
    @objc func getDate(){
        if  datePicker.datePickerMode == .date {
            inputFieldTf.text = datePicker.date.toEnglishString(format: .yearMonthDayWithoutHour)
            //titelLbl.isHidden = false
            //hiehtOfContainerTextField.constant = 30
            containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
            requiredFiledLbl.isHidden = true
        }else{
            requiredFiledLbl.isHidden = true
            inputFieldTf.text = datePicker.date.toString(format: .hourMinute)
           // titelLbl.isHidden = false
            //hiehtOfContainerTextField.constant = 30
            containerOfTextFieldWithLbl.borderColor = containerOfTextFieldborderColor
            requiredFiledLbl.isHidden = true
        }
    }
    // MARK: - get Date from data picker english only
    func getDateOrTimeEnglishOnly() -> String{
        if  datePicker.datePickerMode == .date {
            
            return datePicker.date.toEnglishString(format: .dayMonthYear)
        }else{
            return  datePicker.date.toEnglishString(format: .hourMinute)
        }
    }
    
    // MARK: - get Date from data picker english only
    func SetDateOrTimeEnglishOnly(DateString : String){
        if  datePicker.datePickerMode == .date {
            guard let date = Date.getDateFormString(dateEx: DateString) else {return}
            return datePicker.setDate(date, animated: true)
        }else{
            guard let date = Date.getTimeFormString(dateEx: DateString) else {return}
            return datePicker.setDate(date, animated: true)
        }
    }
    
    // MARK: - show Error Text
    func showErrorText(errorText : String = "") {
        if disableRequireText{return}
        if !errorText.trimmingCharacters(in: .whitespaces).isEmpty {
            requiredFiledLbl.text = errorText
        }
       // titelLbl.isHidden = true
        requiredFiledLbl.isHidden = false
        //hiehtOfContainerTextField.constant = 30
        containerOfTextFieldWithLbl.borderColor = .red
    }
    // MARK: -  IBActions
    @IBAction func trailingActionButton(_ sender: Any) {
        if isSecureTextEntry {
            inputFieldTf.isSecureTextEntry.toggle()
            trailingButton.setImage(inputFieldTf.isSecureTextEntry ? #imageLiteral(resourceName: "Show") : #imageLiteral(resourceName: "Show"), for: .normal)
        }else{
            trailingButtonDeleget?.TrailingButtonAction(sender: self)
        }
        trailingButtonPress()
    }
    @IBAction func selectCountrtCode(_ sender: UIButton) {
        selectCountryCode(sender: sender)
    }
}
extension InputView : CountryPickerDelegate {
    // MARK: -  select Country Code
    func selectCountryCode(sender : UIButton){
        
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        
        // delegate
        CountryManager.shared.config.closeButtonTextColor = .white
        picker.delegate = self
        picker.selectedCountry = "en"
      //  self.parentViewController?.present(pickerNavigationController, animated: true)
    }
    func countryPicker(didSelect country: Country) {
        countryCode.text = "+\(country.phoneCode)"
        self.selectedCode = "+\(country.phoneCode)"
        picker.dismiss(animated: true, completion: nil)
    }
}

extension InputView: UITextFieldDelegate{
     func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputFieldTf {
            if dateInput{
                print("DateInput")
                if maximumDate{
                    datePicker.maximumDate = Date()
                }
            }

        }
    }
}
