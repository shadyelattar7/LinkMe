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
        var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}
    
}

class MainStoriesViewModel: BaseViewModel{
    
    // MARK: Properties
    
    let myAccount: MyAccountWorkerProtocol
    private let storiesApi: StoriesAPIProtocol
    private let disposedBag = DisposeBag()
    
    // MARK: Outputs
    
    var storiesData: BehaviorRelay<[UserStoryData]> = .init(value: [])
    var storiesPost: BehaviorRelay<[UserStoryData]> = .init(value: [])
    
    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    // MARK: Init
    
    init(storiesApi: StoriesAPIProtocol = StoriesAPI(), myAccount: MyAccountWorkerProtocol) {
        self.storiesApi = storiesApi
        self.myAccount = myAccount
    }
    
    // MARK: - Outputs -
    
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> = .init()
    
    //MARK: - Inputs -
    func ViewDidLoad(){
        getMyAccountData()
    }
}

// MARK: Fetch stories

extension MainStoriesViewModel {
    func fetchStories() {
        // Why add first item as dummy data ?
        // -> because handle first item to add new story cell.
        self.storiesData.accept([UserStoryData.example])
        self.storiesPost.accept([UserStoryData.example])
        
        storiesApi.fetchStories().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let model):
                guard let stories = model.data?.data, let post = model.post?.data else { return }
                self.storiesData.accept(self.storiesData.value + stories)
                self.storiesPost.accept(self.storiesPost.value + post)
                
                
                
                print("88: \(post)")
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
        }).disposed(by: disposedBag)
    }
    
    func likeStore(storyId: Int, view: UIView){
        storiesApi.likeStory(model: LikeStoryRequestModel(storyID: storyId)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let model):
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .systemGreen)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
        }).disposed(by: disposedBag)
    }
    
    
    func addComment(storyId: Int, comment: String, view: UIView){
        storiesApi.commentStory(model: AddCommentRequestModel(story_id: storyId, comment: comment)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let model):
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .systemGreen)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
        }).disposed(by: disposedBag)
    }
    
    func removeComment(commentId: Int){
        storiesApi.removeCommentStory(model: RemoveCommentRequestModel(comment_id: commentId)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let model):
                // ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .systemGreen)
                print("Model: \(model)")
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
        }).disposed(by: disposedBag)
    }
    
     func getMyAccountData(){
        myAccount.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
                self.myAccountStatus.onNext(model)
            case .failure(let error):
                _ = error.userInfo["NSLocalizedDescription"] as! String
                print("ERROR IN MY ACCOUNT ❌❌❌: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}

