//
//  BottomListSheetViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ScreenState {
    case success
    case error(String)
}

class BottomListSheetViewModel {
    
    // MARK: Properties
    
    private let storiesApi: StoriesAPIProtocol
    private let disposedBag = DisposeBag()
    
    // MARK: Inputs
    
    private let storyID: Int
    var bindToReloadTableViewClosure: (() -> Void)?
    private var listItems: [ItemList] = [] {
        didSet {
            bindToReloadTableViewClosure?()
        }
    }
    
    // MARK: Init
    
    init(storiesApi: StoriesAPIProtocol = StoriesAPI(), listItems: [ItemList], storyID: Int) {
        self.storiesApi = storiesApi
        self.listItems = listItems
        self.storyID = storyID
    }
    
    // MARK: Outputs
    
    private var screenState: PublishSubject<ScreenState> = .init()
    var screenStateObserver: Observable<ScreenState> {
        return screenState.asObserver()
    }
    
    func getStoryID() -> Int {
        return self.storyID
    }
    
    func getNumberOfCells() -> Int {
        return listItems.count
    }
    
    func getItems(indexPath: IndexPath) -> ItemList {
        return listItems[indexPath.row]
    }
}

// MARK: Delete story

extension BottomListSheetViewModel {
    func deleteStory(storyID: Int) {
        let model = DeleteStoryRequestModel(storyID: storyID)
        
        storiesApi.deleteStory(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(_):
                self.screenState.onNext(.success)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.screenState.onNext(.error(errorMessage ?? ""))
            }
        }).disposed(by: disposedBag)
    }
}
