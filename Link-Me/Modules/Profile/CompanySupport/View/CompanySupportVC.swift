//
//  CompanySupportVC.swift
//  Link-Me
//
//  Created by Al-attar on 01/07/2023.
//

import UIKit
import WebKit



class CompanySupportVC: BaseWireFrame<CompanySupportViewModel>, NavigationBarDelegate {

    //MARK: - @IBOutlet -
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var aboutUsView: UIView!
    @IBOutlet weak var aboutUstitle_lbl: UILabel!
    @IBOutlet weak var aboutUsSubtitle_lbl: UILabel!
    
    
    
    //MARK: - Varables -
    var navBartitle: String = ""
    var url: URL!
    
    
    //MARK: - Bind -
    
    override func bind(viewModel: CompanySupportViewModel) {
        setupView()
    }

    //MARK: - Private func -
    
    private func setupView(){
        aboutUsView.isHidden = true
        
        switch viewModel.source{
        case .AboutUs:
            print("AboutUs")
            aboutUsView.isHidden = false
            navBartitle = "About Us"
             url = URL(string: "http://link-me.live/about")
        case .TermsOfServices:
            print("TermsOfServices")
            navBartitle = "Terms Of Services"
            url = URL(string: "http://link-me.live/terms")
        case .PrivacyPolicy:
            print("PrivacyPolicy")
            navBartitle = "Privacy Policy"
            url = URL(string: "http://link-me.live/privacy")
        default:
            print("ERROR IN Company Support Enum")
        }
        
        
        navBar.configure(with: NavigationBarViewModel(navBarTitle: navBartitle), and: self)
        self.webView!.isOpaque = false
        self.webView!.backgroundColor = UIColor.clear
        self.webView!.scrollView.backgroundColor = UIColor.clear
        webView.load(URLRequest(url: url))
    }

    //MARK: - Action -
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
    
}
