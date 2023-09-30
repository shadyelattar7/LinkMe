//
//  GoPremiumViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 23/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol GoPremiumInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol GoPremiumOutputs{
    var supscriptionSubscribeStatus: PublishSubject<BaseResponse> {get set}
    
}

class GoPremiumViewModel: BaseViewModel{
    
    
    private let subscribeApi: SubscribeAPIProtocol
    private let disposedBag = DisposeBag()
    
    // MARK: Init
    
    init(subscribeApi: SubscribeAPIProtocol) {
        self.subscribeApi = subscribeApi
    }
    
    //MARK: - Output
    var supscriptionSubscribeStatus: PublishSubject<BaseResponse> = .init()
}

// MARK: - Supscription Subscribe

extension GoPremiumViewModel {
    
    func supscriptionSubscribe(supscription_plan_id: Int,transction_id: Int, view: UIView){
        subscribeApi.supscriptionSubscribe(model: SupscriptionSubscribeRequestModel(supscription_plan_id: supscription_plan_id, transction_id: transction_id, paid_by: "ios")).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                 ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .systemGreen)
                self.supscriptionSubscribeStatus.onNext(model)
                print("Model: \(model)")
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
            }
        }).disposed(by: disposedBag)
    }
    
}
