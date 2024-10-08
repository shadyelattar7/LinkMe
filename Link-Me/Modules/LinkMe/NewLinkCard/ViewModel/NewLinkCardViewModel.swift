//
//  NewLinkCardViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 19/08/2024.
//

import RxSwift
import RxCocoa

class NewLinkCardViewModel: BaseViewModel {
    
    // MARK: - Properties
    var oneUsersModel: PublishSubject<User> = .init()
    var acceptChat: PublishSubject<ChatUserInfo> = .init()
    let userID: Int
    let chatID: Int
    
    //MARK: - Private Properties
    private let linkMeApi: LinkMeAPIProtocol
    private let chatApi: ChatWorkerProtocol
    private let disposeBag = DisposeBag()
    
    init(
        linkMeApi: LinkMeAPIProtocol = LinkMeAPI(),
        chatApi: ChatWorkerProtocol = ChatWorker(),
        userID: Int,
        chatID: Int
    ) {
        self.linkMeApi = linkMeApi
        self.chatApi = chatApi
        self.userID = userID
        self.chatID = chatID
    }
    
    func viewDidLoad() {
        fetchUserData()
    }
}

// MARK: Fetch top users
 extension NewLinkCardViewModel {
    func fetchUserData() {
        linkMeApi.fetchOneUser(userID: userID).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.oneUsersModel.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
        }).disposed(by: disposeBag)
    }
    
    func acceptChatRequest() {
        let model = ChatRequestAcceptModel(requestId: chatID)
        chatApi.acceptChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.acceptChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
}
