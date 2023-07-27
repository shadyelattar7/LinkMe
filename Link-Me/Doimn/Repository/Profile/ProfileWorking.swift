//
//  CompleteProfileWorking.swift
//  Link-Me
//
//  Created by Al-attar on 17/06/2023.
//

import Foundation
import RxSwift

protocol ProfileWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func getCountries() -> Observable<Result<BaseResponseGen<[Countries]>, NSError>>
    
    func completeProfile(model: CompleteProfileRequestModel) -> Observable<Result<BaseResponseGen<User>, NSError>>
    
    func EditProfile(model: EditProfileRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponse, NSError>>
    
    func changePassword(model: ChangePasswordRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func changeEmail(model: ChangeEmailRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func confirmUpdateEmail(model: ConfirmUpdateEmailRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func  getTickets(ticket_type: String) -> Observable<Result<BaseMyTickets, NSError>>
    
    func sendEmail(model: SendEmailRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func feedback(model: FeedbackRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func getRemoveAccReason() -> Observable<Result<BaseResponseGen<[RemoveAccReason]>, NSError>>
    
    func deleteAccount(model: DeleteAccountRequestModel) -> Observable<Result<BaseResponse, NSError>>
}


class ProfileWorker: APIClient<ProfileNetworking>, ProfileWorkerProtocol{
  
    func getCountries() -> Observable<Result<BaseResponseGen<[Countries]>, NSError>> {
        self.performRequest(target: .getCountries)
    }
    
    func completeProfile(model: CompleteProfileRequestModel) -> Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performRequest(target: .completeProfile(Parameters: model), requestModel: model)
    }
    
    func EditProfile(model: EditProfileRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponse, NSError>> {
        self.performMultipartRequest(target: .EditProfile(Parameters: model, fileModel: fileModel))
    }
    
    func changePassword(model: ChangePasswordRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .changePassword(Parameters: model), requestModel: model)
    }
    
    func changeEmail(model: ChangeEmailRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .changeEmail(Parameters: model), requestModel: model)
    }
    
    func confirmUpdateEmail(model: ConfirmUpdateEmailRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .confirmUpdateEmail(Parameters: model), requestModel: model)
    }
    
    func getTickets(ticket_type: String) -> Observable<Result<BaseMyTickets, NSError>> {
        self.performRequest(target: .MyTickets(ticket_type: ticket_type))
    }
    
    func sendEmail(model: SendEmailRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .sendEmail(Parameters: model), requestModel: model)
    }
    
    func feedback(model: FeedbackRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .feedback(Parameters: model), requestModel: model)
    }
    
    func getRemoveAccReason() -> Observable<Result<BaseResponseGen<[RemoveAccReason]>, NSError>> {
        self.performRequest(target: .reasonRemoveAcc)
    }
    
    func deleteAccount(model: DeleteAccountRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .DeleteAccount(Parameters: model), requestModel: model)
    }
    
}
