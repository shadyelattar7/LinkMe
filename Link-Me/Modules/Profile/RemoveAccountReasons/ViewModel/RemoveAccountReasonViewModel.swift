//
//  RemoveAccountReasonViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol RemoveAccountReasonInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol RemoveAccountReasonOutputs{
    
    
}

class RemoveAccountReasonViewModel: BaseViewModel, RemoveAccountReasonInputs, RemoveAccountReasonOutputs{
    
    
    let RemoveAccountReason: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    var reasons: BehaviorRelay<[RemoveAccReason]> = .init(value: [])
    
    init(RemoveAccountReason: ProfileWorkerProtocol) {
        self.RemoveAccountReason = RemoveAccountReason
    }
    
    //MARK: - Output -
    
    func viewDidload(view: UIView){
        getReasonRemoveAcc(view: view)
    }
    
    //MARK: - API Call
    
    func getReasonRemoveAcc(view: UIView){
        RemoveAccountReason.getRemoveAccReason().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.reasons.accept(model.data ?? [])
                
                var update = self.reasons.value
                update.insert(RemoveAccReason(id: 0, title_ar: "Other", title_en: "Other", created_at: "", updated_at: "", lang: "Other"), at: self.reasons.value.count)
                self.reasons.accept(update)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
}

