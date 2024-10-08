//
//  SearchingForUsersViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SearchingForUsersViewModel {
    
    // MARK: Properties
    
    private var requestModel: SearchRequestModel?
    private var worker: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(requestModel: SearchRequestModel?, worker: LinkMeAPIProtocol = LinkMeAPI()) {
        self.requestModel = requestModel
        self.worker = worker
        self.searchingForUsers()
    }
    
    // MARK: Outputs
    
    private var users: [User] = []
    var bindToOpenSearchClosure: (() -> Void)?
    private var user: User? = nil {
        didSet {
            bindToOpenSearchClosure?()
        }
    }
    
    func generateRequestChatModel() -> RequestChatModel {
        let targetUserImageView = UIImageView()
        let targetUserImageViewUrl = URL(string: user?.imagePath ?? "")
        targetUserImageView.setImage(url: targetUserImageViewUrl)
        
        let currentUserImageView = UIImageView()
        let currentUserImageViewUrl = URL(string: UDHelper.fetchUserData?.imagePath ?? "")
        currentUserImageView.setImage(url: currentUserImageViewUrl)
        
        let isSpacialRequest: Int = self.requestModel == nil ? 0 : 1
        let model = RequestChatModel(userId: user?.id ?? -0,
                                     isSpecialSearch: isSpacialRequest,
                                     currentUserImageView: currentUserImageView.image ?? .placeholder,
                                     targetUserImageView: targetUserImageView.image ?? .placeholder,
                                     userName:  user?.name ?? "",
                                     userAge: String(user?.birth_date?.calculateAge() ?? 0),
                                     userCountry: user?.country ?? "")
        
        return model
    }
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
}

// MARK: Searching for users

extension SearchingForUsersViewModel {
    private func searchingForUsers() {
        worker.searchingForUsers(model: requestModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                guard let users = model.data else { return }
                
                self.users = users
                self.fetchRandomUser()
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
    
    func fetchRandomUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else {return}
            print("self.users: \(self.users)")
            //        self.user = self.users.randomElement()
            //    print("User: \(user)")
            
            self.user = User(
                id: 29,
                name: "badr10",
                email: "badr10@gmail.com",
                birth_date: "1990-05-31",
                image: "",
                email_verified_at: nil,
                created_at: "2023-05-25T09:18:46.000000Z",
                country_id: nil,
                gander: "male",
                bio: nil,
                is_online: 0,
                is_following: 0,
                is_available: 0,
                user_name: "badr10",
                imagePath: "https://link-me.live/uploads/05-2023/yioWvVNYLn.", lastSeen: "",
                is_profile_completed: 0,
                country: "",
                sent_tickets: 0,
                unread_tickets: 0,
                canAddStory: 1,
                followers: 0,
                diamonds: nil,
                is_star: 0,
                chat_id: 0,
                is_blocked: 0,
                links: 0,
                likes: 0,
                is_link: 0,
                last_availablity: "",
                blocks_number: 0,
                can_see_links: 0,
                can_see_followers: 0,
                can_see_likes: 0,
                is_subscribed: 0
            )
            //            self.users.forEach { user in
            //                if user.email == "abdelrahmanssss@gmail.com"{
            //                    self.user = user
            //                }
            //            }
        }
    }
}
