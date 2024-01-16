//
//  MainNavigator.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import UIKit

class MainNavigator: Navigator{
    
    var coordinator: Coordinator
    
    
    enum Destination{
        //MARK: - LinkMe -
        
        case LinkMe
        case userCard(direction: UserCardDirection, userModel: UserCardModel)
        case newLink
        case notificationList
        case purchases
        case beInTheTop(viewModel: BeInTopViewModel, cardModel: BeInTopModel)
        case letsGoSearch
        case startSearch
        case searchType
        case filterSearch
        case searchingForUsers(requestModel: SearchRequestModel?)
        case requestChatState(requestChatModel: RequestChatModel)
        case aboutStars
        case chat(chatID: String)
        
        // MARK: Messages
        
        case messageList
        case deleteChats(chatsID: [Int])
        
        //MARK: - Stories -
        case MainStory
        case MediaPreview(mediaType: MediaType, image: UIImage = UIImage(), video: URL = URL(fileURLWithPath: ""))
        case StoryPreview
        case ReportStory(storyID: Int)
        case BottomListItem(listItems: [ItemList], itemID: Int)
        case FeaturesPremium
        case GoPremium
        case TestPremuim
        
        //MARK: - Profile -
        case Profile
        case CompleteProfile
        case EditProfile
        case Settings
        case OtherSettings
        case changePassword
        case changeEmail
        case changeLanguage
        case Support
        case SendEmail
        case Feedback
        case CompanySupport(source: CompanySupportEnum)
        case RemoveAccountReason
        case RemoveAccount(reason: String)
        case DeleteAccount(reason: String)
        
        
    }
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    
    func viewcontroller(for destination: Destination) -> UIViewController {
        switch destination{
        case .LinkMe:
            let repo = FCMTokenWorker()
            let viewModel = LinkMeViewModel(fcmToken: repo)
            return LinkMeViewController(viewModel: viewModel, coordinator: coordinator)
        case .userCard(let direction, let userModel):
            let viewModel = UserCardViewModel()
            return UserCardViewController(viewModel: viewModel, coordinator: coordinator, direction: direction, userModel: userModel)
        case .newLink:
            return NewLinkCardViewController(coordinator: self.coordinator)
        case .notificationList:
            return NotificationListViewController()
        case .purchases:
            let myAccountRepo = MyAccountWorker()
            let purchaseStoreRepo = PurchaseStoreAPI()
            let viewModel = PurchaseStoreViewModel(PurchaseStore: purchaseStoreRepo, myAccount: myAccountRepo)
            return PurchaseStoreViewController(viewModel: viewModel, coordinator: coordinator)
        case .beInTheTop(let viewModel, let cardModel):
            return BeInTopViewController(viewModel: viewModel, coordinator: coordinator, cardModel: cardModel)
        case .letsGoSearch:
            return LetsSearchViewController(coordinator: coordinator)
        case .startSearch:
            return StartSearchViewController(coordinator: coordinator)
        case .searchType:
            return SearchTypeViewController(coordinator: coordinator)
        case .filterSearch:
            let viewModel = FilterSearchViewModel()
            return FilterSearchViewController(viewModel: viewModel, coordinator: coordinator)
        case .searchingForUsers(let model):
            let viewModel = SearchingForUsersViewModel(requestModel: model)
            return SearchingForUsersViewController(viewModel: viewModel, coordinator: coordinator)
        case .requestChatState(let requestChatModel):
            let viewModel = RequestChatStateViewModel()
            return RequestChatStateViewController(viewModel: viewModel, coordinator: coordinator, requestChatModel: requestChatModel)
        case .aboutStars:
            let viewModel = AboutStarsViewModel()
            return AboutStarsViewController(viewModel: viewModel, coordinator: coordinator)
        case .chat(let chatID):
            return ChatViewController(viewModel: ChatViewModel(chatID: chatID), coordinator: coordinator)
            
            // MARK: Message
            
        case .messageList:
            let viewModel = MessageListViewModel()
            return MessageListViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .deleteChats(let chatsID):
            let viewModel = DeleteChatSheetViewModel(chatsID: chatsID)
            return DeleteChatSheetViewController(viewModel: viewModel, coordinator: coordinator)
            
            //MARK: - Stories -
            
        case .MainStory:
            let myAccountRepo = MyAccountWorker()
            let viewModel = MainStoriesViewModel(myAccount: myAccountRepo)
            return MainStoriesVC(viewModel: viewModel, coordinator: coordinator)
        case .MediaPreview(let mediaType, let image, let video):
            let viewModel = MediaPreviewViewModel(mediaType: mediaType, image: image, video: video)
            return MediaPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .StoryPreview:
            let repoMyAcc = MyAccountWorker()
            let viewModel = MainStoriesViewModel(myAccount: repoMyAcc)
            return StoryPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .ReportStory(let storyID):
            let viewModel = ReportStoryViewModel(storyID: storyID)
            return ReportStoryViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .BottomListItem(let listItems, let itemID):
            let viewModel = BottomListSheetViewModel(listItems: listItems, itemID: itemID)
            return BottomListSheet(viewModel: viewModel, coordinator: coordinator)
            
            //MARK: - Profile -

        case .Profile:
            let myAccountRepo = MyAccountWorker()
            let viewModel = ProfileViewModel(myAccount: myAccountRepo)
            return ProfileVC(viewModel:viewModel , coordinator: coordinator)
        case .CompleteProfile:
            let completeProfileRepo = ProfileWorker()
            let viewModel = CompleteProfileViewModel(completeProfile: completeProfileRepo)
            return CompleteProfileVC(viewModel: viewModel, coordinator: coordinator)
        case .EditProfile:
            let completeProfileRepo = ProfileWorker()
            let viewModel = EditProfileViewModel(editProfile: completeProfileRepo)
            return EditProfileVC(viewModel: viewModel, coordinator: coordinator)
        case .Settings:
            let viewModel = SettingsViewModel()
            return SettingsVC(viewModel: viewModel, coordinator: coordinator)
        case .OtherSettings:
            let viewModel = OtherSettingsViewModel()
            return OtherSettingsVC(viewModel: viewModel, coordinator: coordinator)
        case .changePassword:
            let completeProfileRepo = ProfileWorker()
            let viewModel = ChangePasswordViewModel(changePassword: completeProfileRepo)
            return ChangePasswordVC(viewModel: viewModel, coordinator: coordinator)
        case .changeEmail:
            let profileRepo = ProfileWorker()
            let viewModel = ChangeEmailViewModel(changeEmail: profileRepo)
            return ChangeEmailVC(viewModel: viewModel, coordinator: coordinator)
        case .changeLanguage:
            let viewModel = LanguageViewModel()
            return LanguageVC(viewModel: viewModel, coordinator: coordinator)
        case .Support:
            let supportProfileRepo = ProfileWorker()
            let viewModel = SupportViewModel(Support: supportProfileRepo)
            return SupportVC(viewModel: viewModel, coordinator: coordinator)
        case .Feedback:
            let repo = ProfileWorker()
            let viewModel = FeedbackViewModel(feedbackRepo: repo)
            return FeedbackVC(viewModel: viewModel, coordinator: coordinator)
        case .CompanySupport(let source):
            let viewModel = CompanySupportViewModel(source: source)
            return CompanySupportVC(viewModel: viewModel, coordinator: coordinator)
        case .SendEmail:
            let sendEmailProfileRepo = ProfileWorker()
            let viewModel = SendEmailViewModel(sendEmail: sendEmailProfileRepo)
            return SendEmailVC(viewModel: viewModel, coordinator: coordinator)
        case .RemoveAccountReason:
            let RemoveAccountReasonRepo = ProfileWorker()
            let viewModel = RemoveAccountReasonViewModel(RemoveAccountReason: RemoveAccountReasonRepo)
            return RemoveAccountReasonVC(viewModel: viewModel, coordinator: coordinator)
        case .RemoveAccount(let reason):
            let viewModel = RemoveAccountViewModel(reason: reason)
            return RemoveAccountVC(viewModel: viewModel, coordinator: coordinator)
        case .DeleteAccount(let reason):
            let DeleteAccountProfileRepo = ProfileWorker()
            let viewModel = DeleteAccountViewModel(DeleteAccount: DeleteAccountProfileRepo, reason: reason)
            return DeleteAccountVC(viewModel: viewModel, coordinator: coordinator)
        case .TestPremuim:
            let viewModel = TestPremuimViewModel()
            return TestPremuimViewController(viewModel: viewModel, coordinator: coordinator)
        case .FeaturesPremium:
            let viewModel = FeaturesPremiumViewModel()
            return FeaturesPremiumVC(viewModel: viewModel, coordinator: coordinator)
        case .GoPremium:
            let subscribeApi = SubscribeAPI()
            let viewModel = GoPremiumViewModel(subscribeApi: subscribeApi)
            return GoPremiumVC(viewModel: viewModel, coordinator: coordinator)
        }
    }
}
