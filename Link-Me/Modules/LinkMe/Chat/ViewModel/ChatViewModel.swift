//
//  ChatViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import Foundation
import RxSwift


class ChatViewModel: BaseViewModel {
    
    // MARK:  proprites
    
    private let worker: ChatWorkerProtocol = ChatWorker()
    private let disposeBag = DisposeBag()
    private var error: (String) -> Void = { _ in }
    private var messageType: ChatMessageType?
    private var mediaMessageType: ChatMessageMediaType?
    private var messageText: String?
    private var mediaData: Data?

    private var onReloadTableViewClosure: (() -> Void) = { }
    private var messages: [MessageModel] = [] {
        didSet {
            onReloadTableViewClosure()
        }
    }
    
    
    // MARK: Init
    
    override init() {
        super.init()
        self.fetchMessages()
    }
}

// MARK: ViewModel inputs

extension ChatViewModel: ChatViewModelInputs {
    func updateMessageType(_ type: ChatMessageType) {
        messageType = type
    }
    
    func updateMediaMessageType(_ type: ChatMessageMediaType) {
        mediaMessageType = type
    }
    
    func updateMessageText(_ text: String?) {
        messageText = text
    }
    
    func updateMediaData(_ data: Data?) {
        mediaData = data
    }
}

// MARK: ViewModel outputs

extension ChatViewModel: ChatViewModelOutputs {
    var numberOfCells: Int {
        return messages.count
    }
    
    func getItemCell(indexPath: IndexPath) -> MessageModel {
        return messages[indexPath.row]
    }
    
    func onReloadTableView(reload: @escaping () -> Void) {
        onReloadTableViewClosure = reload
    }
    
    func onChangeError(error: @escaping (String) -> Void) {
        self.error = error
    }
}


// MARK: Fetch messages form firebase

extension ChatViewModel {
    func fetchMessages() {
        // TODO: - Fetching... messages form firebase to fill with it chat tableview.
        
        
        /// Just dummy data.
        ///
        let content1 = MessageContentModel(content: "Hello, How Are you?",
                                           createdAt: "",
                                           path: "",
                                           receiverId: "",
                                           senderId: "\(UDHelper.fetchUserData?.id ?? 0)",
                                           type: .text)
        let message1 = MessageModel(ReceiverID: "",
                                    SenderID: "\(UDHelper.fetchUserData?.id ?? 0)",
                                    chatId: "",
                                    messages: content1,
                                    timeStamp: 0)
        
        let content2 = MessageContentModel(content: "Hello, i am good and you?",
                                           createdAt: "",
                                           path: "",
                                           receiverId: "",
                                           senderId: "",
                                           type: .text)
        let message2 = MessageModel(ReceiverID: "",
                                    SenderID: "",
                                    chatId: "",
                                    messages: content2,
                                    timeStamp: 0)
        
        
        let content3 = MessageContentModel(content: "",
                                           createdAt: "",
                                           path: "https://file-examples.com/storage/fe02dbc794655b5e699ae4d/2017/11/file_example_MP3_700KB.mp3",
                                           receiverId: "",
                                           senderId: "",
                                           type: .audio)
        let message3 = MessageModel(ReceiverID: "",
                                    SenderID: "",
                                    chatId: "",
                                    messages: content3,
                                    timeStamp: 0)
        
        
        messages.append(message1)
        messages.append(message2)
        messages.append(message3)
    }
}


// MARK: Send message to firebase

extension ChatViewModel {
    func sendMessage() {
        
        let model = ChatMessageRequestModel(chatId: "1", message: messageText, type: messageType?.rawValue, mediaType: mediaMessageType?.rawValue)
        
        let multiPartList = createMultiPartData()
        
        worker.sendMessage(model: model, fileModel: multiPartList).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                print("model", model.data?.message)

            case .failure(let error):
                self.error(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    
    private func createMultiPartData()-> [MultiPartData] {
        guard let mediaData = self.mediaData, messageType == .file else { return [] }
        
        var multiPartList = [MultiPartData]()
        
        switch mediaMessageType {
        case .image:
            let multiPart = MultiPartData(keyName: "media", fileData: mediaData, mimeType: "image/jpeg", fileName: "image.jpeg")
            multiPartList = [multiPart]
            
        case .sound:
            let multiPart = MultiPartData(keyName: "media", fileData: mediaData, mimeType: "audio/m4a", fileName: "audio.m4a")
            multiPartList = [multiPart]
            
        default:
            break
        }
       
        return multiPartList
    }
}
