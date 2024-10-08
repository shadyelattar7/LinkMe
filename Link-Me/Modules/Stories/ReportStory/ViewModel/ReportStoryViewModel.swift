//
//  ReportStoryViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ReportFrom {
    case story
    case chat
}

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
    var storyID: Int?
    var friendID: Int?
    var reportFrom: ReportFrom
    
    // MARK: Outputs
   
    private var reportStoryState: PublishSubject<ReportStoryState> = .init()
    var reportStoryObserver: Observable<ReportStoryState> {
        return reportStoryState.asObserver()
    }
    
    // MARK: Init
    
    init(
        storyID: Int,
        friendID: Int,
        reportFrom: ReportFrom,
        storiesApi: StoriesAPIProtocol = StoriesAPI()
    ) {
        self.storyID = storyID
        self.friendID = friendID
        self.reportFrom = reportFrom
        self.storiesApi = storiesApi
    }
}

// MARK: Report story

extension ReportStoryViewModel {
    func reportStory() {
        let model = ReportStoryRequestModel(storyID: storyID ?? 0, reason: reportReason.value)
        
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
    
    func reportUser() {
        let model = ReportUserRequestModel(friendID: self.friendID)
        print("friendID: \(self.friendID)")
        storiesApi.reportUser(model: model).subscribe(onNext:{ [weak self] result in
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
