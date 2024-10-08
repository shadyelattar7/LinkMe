//
//  UserCardViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

/// Type of user card .
///
enum UserCardDirection {
    case profile
    case profileWithRequestChat
}

class UserCardViewModel: BaseViewModel{
    
    // MARK: - Properties
    let direction: UserCardDirection
    var oneUsersModel: PublishSubject<User> = .init()
    var acceptChat: PublishSubject<ChatUserInfo> = .init()
    var refuseChat: PublishSubject<ChatUserInfo> = .init()
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
        chatID: Int,
        direction: UserCardDirection
    ) {
        self.linkMeApi = linkMeApi
        self.chatApi = chatApi
        self.userID = userID
        self.chatID = chatID
        self.direction = direction
    }
    
    func viewDidLoad() {
        fetchUserData()
    }
}

// MARK: Network Calls
extension UserCardViewModel {
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
    
    func refuseChatRequest() {
        let model = ChatRequestRefuseModel(requestId: chatID)
        chatApi.refuseChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.refuseChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
}
