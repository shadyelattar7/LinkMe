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
        case userCard(direction: UserCardDirection)
        
        //MARK: - Stories -
        case MediaPreview(mediaType: MediaType, image: UIImage = UIImage(), video: URL = URL(fileURLWithPath: ""))
        case StoryPreview
        case ReportStory(storyID: Int)
        case BottomListItem(listItems: [ItemList], storyID: Int)
        
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
            return LinkMeViewController(viewModel: LinkMeViewModel(), coordinator: coordinator)
            
        case .userCard(let direction):
            let viewModel = UserCardViewModel()
            return UserCardViewController(viewModel: viewModel, coordinator: coordinator, direction: direction)
            
            //MARK: - Stories -
            
        case .MediaPreview(let mediaType, let image, let video):
            let viewModel = MediaPreviewViewModel(mediaType: mediaType, image: image, video: video)
            return MediaPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .StoryPreview:
            let viewModel = MainStoriesViewModel()
            return StoryPreviewVC(viewModel: viewModel, coordinator: coordinator)
        case .ReportStory(let storyID):
            let viewModel = ReportStoryViewModel(storyID: storyID)
            return ReportStoryViewController(viewModel: viewModel, coordinator: coordinator)
            
        case .BottomListItem(let listItems, let storyID):
            let viewModel = BottomListSheetViewModel(listItems:  listItems, storyID: storyID)
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
            
            
            
        }
    }
}
