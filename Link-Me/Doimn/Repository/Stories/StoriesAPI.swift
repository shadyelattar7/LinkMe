//
//  StoriesWorking.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import Foundation
import RxSwift

protocol StoriesAPIProtocol {
    
    /// it is the method used to update new story
    /// - Parameters:
    ///   - params: story text and story image or story video.
    /// - Returns: baseResponse model.
    func addNewStory(model: AddNewStoryRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to fetch all stories
    /// - Parameters:
    /// - Returns: Stories model.
    func fetchStories() -> Observable<Result<StoriesModel, NSError>>
    
    /// it is the method used to delete story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func deleteStory(model: DeleteStoryRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func reportStory(model: ReportStoryRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func likeStory(model: LikeStoryRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func commentStory(model: AddCommentRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func removeCommentStory(model: RemoveCommentRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    
    /// it is the method used to block user.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func blockUser(model: BlockUserRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report user in chat.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func reportUser(model: ReportUserRequestModel) -> Observable<Result<BaseResponse, NSError>>
}

class StoriesAPI: APIClient<StoriesTarget>, StoriesAPIProtocol {
   
    func addNewStory(model: AddNewStoryRequestModel, fileModel: [MultiPartData]) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performMultipartRequest(target: .addNewStory(Parameters: model, fileModel: fileModel))
    }
    
    func fetchStories() -> Observable<Result<StoriesModel, NSError>> {
        self.performRequest(target: .fetchStories)
    }
    
    func deleteStory(model: DeleteStoryRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .deleteStory(Parameters: model), requestModel: model)
    }
    
    func reportStory(model: ReportStoryRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .reportStory(Parameters: model), requestModel: model)
    }
    
    func likeStory(model: LikeStoryRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .likeStory(Parameters: model), requestModel: model)
    }
    
    func commentStory(model: AddCommentRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .comment(Parameters: model), requestModel: model)
    }
    
    func removeCommentStory(model: RemoveCommentRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .removeComment(Parameters: model), requestModel: model)
    }
   
    func blockUser(model: BlockUserRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .blockUser(parameters: model), requestModel: model)
    }
    
    func reportUser(model: ReportUserRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .reportUser(parameters: model), requestModel: model)
    }
}
