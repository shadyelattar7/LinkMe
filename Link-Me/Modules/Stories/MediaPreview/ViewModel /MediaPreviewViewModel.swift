//
//  MediaPreviewViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 12/09/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum MediaType{
    case image
    case video
}

//MARK: - ViewController -> ViewModel
protocol MediaPreviewViewModelInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol MediaPreviewViewModelOutputs{
//    var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class MediaPreviewViewModel: BaseViewModel,MediaPreviewViewModelInputs,MediaPreviewViewModelOutputs{
    
    let mediaType: MediaType
    let disposedBag = DisposeBag()
    var image: UIImage?
    var video: URL?
    
    init(mediaType: MediaType,image: UIImage,video: URL) {
        self.mediaType = mediaType
        self.image = image
        self.video = video
    }
}
