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
        let currentUserImageViewUrl = URL(string: user?.imagePath ?? "")
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
            self.user = self.users.randomElement()
        }
    }
}
