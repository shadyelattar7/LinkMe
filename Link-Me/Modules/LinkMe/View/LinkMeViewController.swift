//
//  LinkMeViewController.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit
import MOLH

class LinkMeViewController: BaseWireFrame<LinkMeViewModel> {
    
    // MARK: - Properties -
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
        
    }
    
    
    override func bind(viewModel: LinkMeViewModel) {
        
    }
    
    private func setupView(){
        UDHelper.isChangeLang = false
        
       
    }
}


