//
//  FeedbackVC.swift
//  Link-Me
//
//  Created by Al-attar on 30/06/2023.
//

import UIKit
import UITextView_Placeholder

enum FeedbackType: String{
    case suggestion = "suggestion"
    case complain = "complain"
}

class FeedbackVC: BaseWireFrame<FeedbackViewModel>, NavigationBarDelegate {

    //MARK: - @IBOutlet -
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var title_tf: InputView!
    @IBOutlet weak var email_tf: InputView!
    @IBOutlet weak var SuggestionView: UIView!
    @IBOutlet weak var SuggestionTitle_lbl: UILabel!
    @IBOutlet weak var ComplaintView: UIView!
    @IBOutlet weak var ComplaintTitle_lbl: UILabel!
    @IBOutlet weak var description_tv: UITextView!
    @IBOutlet weak var save_btn: MainButton!
    
    //MARK: - Variables -
    var feedbackType: FeedbackType = .suggestion
    
    //MARK: - Bind -
    
    override func bind(viewModel: FeedbackViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func -
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Feedback".localized), and: self)
        description_tv.placeholder = "How We Can Help You!".localized
        title_tf.placeholder = "Write Tittle".localized
        email_tf.placeholder = "Email".localized
        selectSuggestion()
        save_btn.MainBtn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func subscriptions(){
        viewModel.feedbackStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
    
    }
    
    private func selectSuggestion(){
        SuggestionView.backgroundColor = .LinkMeUIColor.lightPurple
        SuggestionTitle_lbl.textColor = .LinkMeUIColor.mainColor
    
        ComplaintView.backgroundColor = .LinkMeUIColor.lightGray
        ComplaintTitle_lbl.textColor = .LinkMeUIColor.strongGray
    }
    
    private func selectComplaint(){
        ComplaintView.backgroundColor = .LinkMeUIColor.lightPurple
        ComplaintTitle_lbl.textColor = .LinkMeUIColor.mainColor
       
        SuggestionView.backgroundColor = .LinkMeUIColor.lightGray
        SuggestionTitle_lbl.textColor = .LinkMeUIColor.strongGray
    }
    
    //MARK: - Actions -
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
    
    @objc func saveTapped(){
        guard email_tf.validate(for: .email) else {return}
        self.viewModel.feedback(email: email_tf.text, title: title_tf.text, description: description_tv.text, type: feedbackType.rawValue, view: self.view)
    }
     
    
    @IBAction func SuggestionTapped(_ sender: Any) {
        selectSuggestion()
    }
    
    
    @IBAction func ComplaintTapped(_ sender: Any) {
        selectComplaint()
    }
    
}
