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
        case userCard(userID: Int, chatID: Int, direction: UserCardDirection)
        case newLink(userID: Int, chatID: Int)
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
        case chat(chatID: String, chatFrom: ChatType)
        case ImagePreview(viewModel: ChatViewModel)
        case RequestChatView(chatID: String)
        
        // MARK: Messages
        
        case messageList
        case deleteChats(chatsID: [Int])
        case friends
        
        //MARK: - Stories -
        case MainStory
        case MediaPreview(mediaType: MediaType, image: UIImage = UIImage(), video: URL = URL(fileURLWithPath: ""))
        case StoryPreview
        case ReportStory(storyID: Int = 0, friendID: Int = 0, reportFrom: ReportFrom)
        case BottomListItem(listItems: [ItemList], itemID: Int)
        case FeaturesPremium
        case GoPremium
        case TestPremuim
        
        //MARK: - Profile -
        case Profile
        case CompleteProfile(fromAuth:Bool)
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
        case blockUser
        case unblockUser(parameter: UnblockUserModel)
        
        
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
        case .userCard(let userID, let chatID, let direction):
            let repo = LinkMeAPI()
            let chatRepo = ChatWorker()
            let viewModel = UserCardViewModel(linkMeApi: repo, chatApi: chatRepo, userID: userID, chatID: chatID, direction: direction)
            return UserCardViewController(viewModel: viewModel, coordinator: coordinator)
        case .newLink(let userID, let chatID):
            let repo = LinkMeAPI()
            let chatRepo = ChatWorker()
            let viewModel = NewLinkCardViewModel(linkMeApi: repo, chatApi: chatRepo, userID: userID, chatID: chatID)
            return NewLinkCardViewController(viewModel: viewModel, coordinator: coordinator)
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
        case .chat(let chatID, let chatFrom):
            let viewModel = ChatViewModel(chatID: chatID, chatFrom: chatFrom)
            return ChatViewController(viewModel: viewModel, coordinator: coordinator)
        case .ImagePreview(let viewModel):
            return ImagePreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .RequestChatView(let chatID):
            let viewModel = RequestChatViewModel(chatID: chatID)
            return RequestChatViewController(viewModel: viewModel, coordinator: coordinator)
            
            // MARK: Message
            
        case .messageList:
            let viewModel = MessageListViewModel()
            return MessageListViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .deleteChats(let chatsID):
            let viewModel = DeleteChatSheetViewModel(chatsID: chatsID)
            return DeleteChatSheetViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .friends:
            let viewModel = FriendsViewModel()
            return FriendsViewController(viewModel: viewModel, coordinator: coordinator)
            
            //MARK: - Stories -
            
        case .MainStory:
            let myAccountRepo = MyAccountWorker()
            let viewModel = MainStoriesViewModel(myAccount: myAccountRepo)
            return MainStoriesVC(viewModel: viewModel, coordinator: coordinator)
        case .MediaPreview(let mediaType, let image, let video):
            let myAccountRepo = MyAccountWorker()
            let viewModel = MediaPreviewViewModel(mediaType: mediaType, image: image, video: video, myAccount: myAccountRepo)
            return MediaPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .StoryPreview:
            let repoMyAcc = MyAccountWorker()
            let viewModel = MainStoriesViewModel(myAccount: repoMyAcc)
            return StoryPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .ReportStory(let storyID, let friendID, let reportFrom):
            let viewModel = ReportStoryViewModel(storyID: storyID, friendID: friendID, reportFrom: reportFrom)
            return ReportStoryViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .BottomListItem(let listItems, let itemID):
            let viewModel = BottomListSheetViewModel(listItems: listItems, itemID: itemID)
            return BottomListSheet(viewModel: viewModel, coordinator: coordinator)
            
            //MARK: - Profile -

        case .Profile:
            let myAccountRepo = MyAccountWorker()
            let viewModel = ProfileViewModel(myAccount: myAccountRepo)
            return ProfileVC(viewModel:viewModel , coordinator: coordinator)
        case .CompleteProfile(let fromAuth):
            let completeProfileRepo = ProfileWorker()
            let viewModel = CompleteProfileViewModel(completeProfile: completeProfileRepo,fromAuth: fromAuth)
            return CompleteProfileVC(viewModel: viewModel, coordinator: coordinator)
        case .EditProfile:
            let completeProfileRepo = ProfileWorker()
            let viewModel = EditProfileViewModel(editProfile: completeProfileRepo)
            return EditProfileVC(viewModel: viewModel, coordinator: coordinator)
        case .Settings:
            let settingRepo = ProfileWorker()
            let viewModel = SettingsViewModel(changeOnlineWorker: settingRepo)
            return SettingsVC(viewModel: viewModel, coordinator: coordinator)
        case .OtherSettings:
            let otherSettings = MyBlockWorker()
            let viewModel = OtherSettingsViewModel(blockNetworking: otherSettings)
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
        case .blockUser:
            let blockUserApi = MyBlockWorker()
            let viewModel = BlockUserViewModel(myBlockUser: blockUserApi)
            return BlockUserVC(viewModel: viewModel, coordinator: coordinator)
        case .unblockUser(parameter: let parameter):
            let viewModel = UnBlockerViewModel(user: parameter)
            return UnBlockerAlert(viewModel: viewModel, coordinator: coordinator)
        }
    }
}
struct UnblockUserModel {
    var id: Int
    var image: String
    var name: String
    var description: String
}
