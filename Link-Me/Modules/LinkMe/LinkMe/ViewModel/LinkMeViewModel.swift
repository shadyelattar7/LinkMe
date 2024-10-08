//
//  LinkMeViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class LinkMeViewModel: BaseViewModel {
    
    // MARK: Properties
    private let myAccountWorker: MyAccountWorkerProtocol
    private let linkMeApi: LinkMeAPIProtocol
    private let fcmToken: FCMTokenWorkerProtocol
    private let pusherManager = PusherManager.shared
    private let disposeBag = DisposeBag()
    
    var chatID = PublishSubject<Int>()

    // MARK: Outputs

    var numberOfDiamonds: BehaviorRelay<Int> = .init(value: 0)
    
    private var topUsersModel = BehaviorRelay<TopUserData?>(value: nil)
    var topUsersModelObservable: Observable<TopUserData?> {
        return topUsersModel.asObservable()
    }
    
    private var topUsers = BehaviorRelay<[User]>(value: [])
    var topUsersObservable: Observable<[User]> {
        return topUsers.asObservable()
    }

    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    func getUserModel(_ row: Int) -> User {
        return topUsers.value[row]
    }
    
    func getBeInTopModel() -> BeInTopModel {
        var startsModel: [StarModel] = []
        
        topUsersModel.value?.stars?.forEach({ star in
            let isAvailable = numberOfDiamonds.value >= star.diamonds ?? 0 ? true : false
            startsModel.append(StarModel(id: star.id, diamonds: star.diamonds, titleAr: star.titleAr, titleEn: star.titleEn, isAvailableToChoose: isAvailable))
        })
        
        let model = BeInTopModel(numberOfUsers: topUsers.value.count, stars: startsModel)
        return model
    }

    // MARK: Init

    init(linkMeApi: LinkMeAPIProtocol = LinkMeAPI(), myAccountWorker: MyAccountWorkerProtocol = MyAccountWorker(), fcmToken: FCMTokenWorkerProtocol) {
        self.linkMeApi = linkMeApi
        self.myAccountWorker = myAccountWorker
        self.fcmToken = fcmToken
    }
    
//    deinit {
//        PusherManager.shared.disconnect()
//    }
}

// MARK: Fetch top users

extension LinkMeViewModel {
    func fetchTopUsers() {
        linkMeApi.fetchTopUsers().subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                guard let data = model.data, let users = data.users else { return }
                self.topUsersModel.accept(data)
                self.topUsers.accept(users)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}

// MARK: Fetch Diamonds

extension LinkMeViewModel {
    private func getMyAccountData() {
        myAccountWorker.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.numberOfDiamonds.accept(model.data?.diamonds ?? 0)
                
            case .failure(let error):
                let error = error.userInfo["NSLocalizedDescription"] as! String
                self.errorMessage.onNext(error)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: Send FCM Token

extension LinkMeViewModel {
    func sendFCMToken() {
        fcmToken.sendFCMToken().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                print("Success send fcm token 🟢 \(model)")
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: Request chat
extension LinkMeViewModel {
    func requestChat(userId: Int) {
         let model = RequestChatRequestModel(
            userId: userId,
            message: "",
            isSpecial: 0,
            type: "home"
        )
        
        linkMeApi.requestChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.subscribeRequest(id: data.id ?? 0)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func subscribeRequest(id: Int) {
        pusherManager.subscribeToChannel(channelName: "request-\(id)", eventName: "request-updated") { event in
            let jsonString = event.data
            if let responseData: ResponseData = PusherManager.shared.parseJSON(jsonString: jsonString, type: ResponseData.self) {
                let requestId = responseData.request_id
                let status = responseData.status
                self.chatID.onNext(requestId ?? 0)
            }
        }
    }
}

