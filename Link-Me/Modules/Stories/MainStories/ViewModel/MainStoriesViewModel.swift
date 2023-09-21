//
//  MainStoriesViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 19/07/2023.
//

import Foundation
import RxCocoa
import RxSwift


struct Stories{
    var name: String
    var image: UIImage
    var stories: [UIImage]
}

//MARK: - ViewController -> ViewModel

protocol MainStoriesInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol MainStoriesOutputs{
//    var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class MainStoriesViewModel: BaseViewModel{
    
    // MARK: Properties
    
    private let storiesApi: StoriesAPIProtocol
    private let disposedBag = DisposeBag()

    // MARK: Outputs
    
    var storiesData: BehaviorRelay<[UserStoryData]> = .init(value: [])
    
    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    // MARK: Init
    
    init(storiesApi: StoriesAPIProtocol = StoriesAPI()) {
        self.storiesApi = storiesApi
        super.init()
        self.fetchStories()
    }
}

// MARK: Fetch stories

extension MainStoriesViewModel {
    func fetchStories() {
        storiesApi.fetchStories().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}

            switch result{
            case .success(let model):
                guard let stories = model.dats?.data else { return }
                // Why add first item as dummy data ?
                // -> because handle first item to add new story cell.
                self.storiesData.accept([UserStoryData.example])
                self.storiesData.accept(self.storiesData.value + stories)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
        }).disposed(by: disposedBag)
    }
}
