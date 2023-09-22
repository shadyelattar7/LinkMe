//
//  ReportStoryViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ReportStoryState {
    case success
    case error(String)
}

class ReportStoryViewModel: BaseViewModel {
    
    // MARK: Properties
    
    private let storiesApi: StoriesAPIProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: Inputs
    
    var reportReason = BehaviorRelay<String>(value: "")
    var storyID: Int
    
    // MARK: Outputs
   
    private var reportStoryState: PublishSubject<ReportStoryState> = .init()
    var reportStoryObserver: Observable<ReportStoryState> {
        return reportStoryState.asObserver()
    }
    
    // MARK: Init
    
    init(storyID: Int, storiesApi: StoriesAPIProtocol = StoriesAPI()) {
        self.storyID = storyID
        self.storiesApi = storiesApi
    }
}

// MARK: Report story

extension ReportStoryViewModel {
    func reportStory() {
        let model = ReportStoryRequestModel(storyID: storyID, reason: reportReason.value)
        
        storiesApi.reportStory(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(_):
                self.reportStoryState.onNext(.success)

            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.reportStoryState.onNext(.error(errorMessage ?? ""))
            }
        }).disposed(by: disposeBag)
    }
}
