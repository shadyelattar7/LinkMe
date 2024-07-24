//
//  UnBlockerAlert.swift
//  Link-Me
//
//  Created by Ahmed_POMAC on 24/07/2024.
//

import UIKit

class UnBlockerAlert: BaseWireFrame<UnBlockerViewModel> {
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var descriptionUser: UILabel!
    @IBOutlet weak var confirmDeletion_btn: MainButton!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var cancel_btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func bind(viewModel: UnBlockerViewModel) {
        setupView()
    }
    //MARK: - Private func -
    
    private func setupView(){
        confirmDeletion_btn.MainBtn.addTarget(self, action: #selector(confirmDeletionTapped), for: .touchUpInside)
    }
    
    
    //MARK: - Actions -
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func confirmDeletionTapped(){
        
        print("button tapped")
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
