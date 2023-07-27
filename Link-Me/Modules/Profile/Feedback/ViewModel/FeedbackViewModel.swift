//
//  FeedbackViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 30/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol FeedbackInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol FeedbackOutputs{
    var feedbackStatus: PublishSubject<BaseResponse> {get set}

}

class FeedbackViewModel: BaseViewModel, FeedbackInputs, FeedbackOutputs{
    
    
    let feedbackRepo: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    
    init(feedbackRepo: ProfileWorkerProtocol) {
        self.feedbackRepo = feedbackRepo
    }
    
    //MARK: - Output -
    
    var feedbackStatus: PublishSubject<BaseResponse> = .init()
    
    //MARK: - API Call -

    func feedback(email: String,title: String,description: String,type: String, view: UIView){
        
        let feedbackReqModel = FeedbackRequestModel(email: email, title: title, description: description, type: type)

        feedbackRepo.feedback(model: feedbackReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.feedbackStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
