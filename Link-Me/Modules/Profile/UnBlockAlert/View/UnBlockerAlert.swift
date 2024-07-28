//
//  UnBlockerAlert.swift
//  Link-Me
//
//  Created by Ahmed_POMAC on 24/07/2024.
//

import UIKit
protocol ReloadAfterDismiss {
    func reloadAfter()
}
class UnBlockerAlert: BaseWireFrame<UnBlockerViewModel> {
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var descriptionUser: UILabel!
    @IBOutlet weak var confirmDeletion_btn: MainButton!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var cancel_btn: UIButton!
    var reloadAfterDismiss: ReloadAfterDismiss?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func bind(viewModel: UnBlockerViewModel) {
        setupView()
        if let user = viewModel.user {
            config(blookUser: user)
        }
    }
    //MARK: - Private func -
    
    private func setupView(){
        confirmDeletion_btn.MainBtn.addTarget(self, action: #selector(confirmDeletionTapped), for: .touchUpInside)
    }
    func config(blookUser:UnblockUserModel){
        if let imagurl = URL(string: blookUser.image){
            userPhoto.setImage(url: imagurl)
        }
        nameUser.text = blookUser.name
        descriptionUser.text = blookUser.description
    }
    
    //MARK: - Actions -
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func confirmDeletionTapped(){
        viewModel.setUnBlockUser(view: self.view)
        if viewModel.dismiss {
            reloadAfterDismiss?.reloadAfter()
        }
        print("button tapped")
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
