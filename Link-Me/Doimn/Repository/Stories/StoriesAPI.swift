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
}

class StoriesAPI: APIClient<StoriesTarget>, StoriesAPIProtocol {
    func addNewStory(model: AddNewStoryRequestModel, fileModel: [MultiPartData]) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performMultipartRequest(target: .addNewStory(Parameters: model, fileModel: fileModel))
    }
}
