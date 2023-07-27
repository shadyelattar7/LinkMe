//
//  BaseWireFrame.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD
import RxReachability
import Reachability

protocol ViewModel {
    
}

class BaseWireFrame<T: BaseViewModel>: UIViewController{
    
    var viewModel: T!
    var coordinator: Coordinator!
    
    
    
    lazy var disposeBag = {
        return  DisposeBag()
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        bindStatus()
    }
    
    
    init(viewModel: T,coordinator:  Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    
    
    func bind(viewModel: T){
        fatalError("Please override bind function")
    }
    
    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    func bindStatus(){
        viewModel.displayError.subscribe { [weak self] (text) in
            self?.displayError(text: text)
        }.disposed(by: disposeBag)
        
        
        viewModel.isLoading.subscribe { [weak self] (isLoading) in
            guard let self = self, let isloading = isLoading.element else {return}
            if isloading{
                SVProgressHUD.show()
            }else{
                SVProgressHUD.dismiss()
            }
        }.disposed(by: disposeBag)
        
        
        //MARK:- reachability state binding
        
        Reachability.rx.isReachable.subscribe(onNext: { isReachable in
            if isReachable == false {
                self.displayError(text: "No Network foun...")
            }
        }).disposed(by: disposeBag)
    }
    
    
}



extension BaseWireFrame{
    func displayError(text: String){
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
