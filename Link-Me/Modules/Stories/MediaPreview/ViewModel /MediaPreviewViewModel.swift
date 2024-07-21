//
//  MediaPreviewViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 12/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum MediaPreviewState {
    case success
    case error(String)
}

enum MediaType{
    case image
    case video
}

//MARK: - ViewController -> ViewModel
protocol MediaPreviewViewModelInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol MediaPreviewViewModelOutputs{
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class MediaPreviewViewModel: BaseViewModel, MediaPreviewViewModelInputs, MediaPreviewViewModelOutputs {
   
    // MARK: Properties
    
    private let storiesApi: StoriesAPIProtocol
    private let disposedBag = DisposeBag()
    let myAccount: MyAccountWorkerProtocol
    let mediaType: MediaType
    var image: UIImage?
    var video: URL?
    
    // MARK: Outputs
    
    private var mediaPreviewState: PublishSubject<MediaPreviewState> = .init()
    var mediaPreviewStateObserver: Observable<MediaPreviewState> {
        return mediaPreviewState
    }
    
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> = .init()
    
    // MARK: Init
    
    init(storiesApi: StoriesAPIProtocol = StoriesAPI(), mediaType: MediaType,image: UIImage,video: URL, myAccount: MyAccountWorkerProtocol) {
        self.storiesApi = storiesApi
        self.mediaType = mediaType
        self.image = image
        self.video = video
        self.myAccount = myAccount
    }
}

// MARK: Add new story api.

extension MediaPreviewViewModel {
    func addNewStory() {
        let model = AddNewStoryRequestModel(text: "")
        guard let multiPartData = generateMultiPartData() else { return }
        
        storiesApi.addNewStory(model: model, fileModel: multiPartData).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            Loading.shared.hideProgressView()
            
            switch result{
            case .success(_):
                self.mediaPreviewState.onNext(.success)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.mediaPreviewState.onNext(.error(errorMessage ?? ""))
            }
        }).disposed(by: disposedBag)
    }
    
    private func generateMultiPartData() -> [MultiPartData]? {
        var resultOfMultiPart = [MultiPartData]()
        
        switch mediaType {
        case .image:
            guard let image = self.image, let imageData = image.jpegData(compressionQuality: 0.6) else { return nil }
            let multiPart = MultiPartData(keyName: "video", fileData: imageData, mimeType: "image/jpeg", fileName: "image.jpeg")
            resultOfMultiPart = [multiPart]
            
        case .video:
            do {
                guard let video = video else { return nil }
                let data = try Data(contentsOf: video)
                let multiPart = MultiPartData(keyName: "video", fileData: data, mimeType: video.mimeType(), fileName: "video.mp4")
                resultOfMultiPart = [multiPart]
            } catch {
                self.mediaPreviewState.onNext(.error("Error When catch video."))
            }
        }
        
        return resultOfMultiPart
    }
}


extension MediaPreviewViewModel {
    private func getMyAccountData(){
        myAccount.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
                self.myAccountStatus.onNext(model)
            case .failure(let error):
                _ = error.userInfo["NSLocalizedDescription"] as! String
                print("ERROR IN MY ACCOUNT ❌❌❌: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
