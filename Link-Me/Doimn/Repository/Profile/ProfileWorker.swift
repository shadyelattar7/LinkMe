//
//  CompleteProfileWorker.swift
//  Link-Me
//
//  Created by Al-attar on 17/06/2023.
//

import Foundation
import Alamofire


enum ProfileNetworking: TargetType{
    case getCountries
    case completeProfile (Parameters: CompleteProfileRequestModel)
    case EditProfile(Parameters: EditProfileRequestModel, fileModel: [MultiPartData])
    case changePassword(Parameters: ChangePasswordRequestModel)
    case changeEmail(Parameters: ChangeEmailRequestModel)
    case confirmUpdateEmail(Parameters: ConfirmUpdateEmailRequestModel)
    case MyTickets(ticket_type: String)
    case sendEmail(Parameters: SendEmailRequestModel)
    case feedback(Parameters: FeedbackRequestModel)
    case reasonRemoveAcc
    case DeleteAccount(Parameters: DeleteAccountRequestModel)
    case online
    case available
    case link
}

extension ProfileNetworking{
    var path: String{
        switch self {
        case .getCountries:
            return "/countries"
        case .completeProfile:
            return "/complete-profile"
        case .EditProfile:
            return "/update-profile"
        case .changePassword:
            return "/update-password"
        case .changeEmail:
            return "/update-email"
        case .confirmUpdateEmail:
            return "/confirm-update-email"
        case .MyTickets(let ticket_type):
            return "/tickets?type=suggestion&ticket_type=\(ticket_type)"
        case .sendEmail:
            return "/tickets/store"
        case .feedback:
            return "/contacts/store"
        case .reasonRemoveAcc:
            return "/delete-reasons"
        case .DeleteAccount:
            return "/delete-account"
        case .online:
            return "/toggle-online"
        case .available:
            return "/toggle-available"
        case .link:
            return "/toggle-link"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .getCountries:
            return .get
        case .completeProfile:
            return .post
        case .EditProfile:
            return .post
        case .changePassword:
            return .post
        case .changeEmail:
            return .post
        case .confirmUpdateEmail:
            return .post
        case .MyTickets:
            return .get
        case .sendEmail:
            return .post
        case .feedback:
            return .post
        case .reasonRemoveAcc:
            return .get
        case .DeleteAccount:
            return .post
        case .online:
            return .post
        case .available:
            return .post
        case .link:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .getCountries:
            return .requestPlain
        case .completeProfile(let CompleteProfile):
            return .request(CompleteProfile)
        case .EditProfile(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        case .changePassword(let Parameters):
            return .request(Parameters)
        case .changeEmail(let Parameters):
            return .request(Parameters)
        case .confirmUpdateEmail(let Parameters):
            return .request(Parameters)
        case .MyTickets:
            return .requestPlain
        case .sendEmail(let Parameters):
            return .request(Parameters)
        case .feedback(let Parameters):
            return .request(Parameters)
        case .reasonRemoveAcc:
            return .requestPlain
        case .DeleteAccount(let Parameters):
            return .request(Parameters)
        case .online:
            return .requestPlain
        case .available:
            return .requestPlain
        case .link:
            return .requestPlain
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .getCountries:
            return ["Accept":"application/json"]
        case .completeProfile,
                .EditProfile,
                .changePassword,
                .changeEmail,
                .confirmUpdateEmail,
                .MyTickets,
                .sendEmail,
                .feedback,
                .reasonRemoveAcc,
                .DeleteAccount,
                .online,
                .link,
                .available:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
        
    }
}
