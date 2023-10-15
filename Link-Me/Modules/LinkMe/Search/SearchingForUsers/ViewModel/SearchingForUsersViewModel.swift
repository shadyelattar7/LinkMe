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
        let imageView = UIImageView()
        let imageViewUrl = URL(string: user?.imagePath ?? "")
        imageView.setImage(url: imageViewUrl)

        let model = RequestChatModel(userImageView: imageView.image ?? UIImage(), otherImageView: .placeholder, userName: user?.name ?? "", userAge: String(user?.birth_date?.calculateAge() ?? 0), userCountry: user?.country ?? "")
        
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
            switch result{
            case .success(let model):
                guard let _ = model.data else { return }
                
                // MARK: Just dummy data to test cases.
                
                let myUsers = [User(id: 21, name: "Ahmed Nasr", email: nil, birth_date: "2000-01-11", image: nil, email_verified_at: nil, created_at: nil, country_id: nil, gander: nil, bio: nil, is_online: nil, is_following: nil, is_available: nil, user_name: nil, imagePath: "https://www.w3schools.com/w3css/img_avatar2.png", is_profile_completed: nil, country: nil, sent_tickets: nil, unread_tickets: nil, canAddStory: nil, diamonds: nil), User(id: 40, name: "Ahmed Nasr2", email: nil, birth_date: "2013-01-11", image: nil, email_verified_at: nil, created_at: nil, country_id: nil, gander: nil, bio: nil, is_online: nil, is_following: nil, is_available: nil, user_name: nil, imagePath: "https://www.w3schools.com/w3css/img_avatar2.png", is_profile_completed: nil, country: nil, sent_tickets: nil, unread_tickets: nil, canAddStory: nil, diamonds: nil), User(id: 65, name: "Ahmed Nasr3", email: nil, birth_date: "1990-01-11", image: nil, email_verified_at: nil, created_at: nil, country_id: nil, gander: nil, bio: nil, is_online: nil, is_following: nil, is_available: nil, user_name: nil, imagePath: "https://www.w3schools.com/w3css/img_avatar2.png", is_profile_completed: nil, country: nil, sent_tickets: nil, unread_tickets: nil, canAddStory: nil, diamonds: nil)]
                
                self.users = myUsers
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
            self.user = self.users.randomElement()
        }
    }
}
