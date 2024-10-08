//
//  ChatViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum ChatType: String{
    case home = "home"
    case search = "search"
    case messages = "message"
}

enum MediaPreview {
    case send
    case preview
}

class ChatViewModel: BaseViewModel {
    
    // MARK:  proprites
    private let pusherManager = PusherManager.shared
    var chatID: String
    private let worker: ChatWorkerProtocol = ChatWorker()
    private let workerLinkMeAPI: LinkMeAPIProtocol = LinkMeAPI()
    private let disposeBag = DisposeBag()
    private var error: (String) -> Void = { _ in }
    private var messageType: ChatMessageType?
    private var mediaMessageType: ChatMessageMediaType?
    private var messageText: String?
    private var mediaData: Data?
    private var videoData: URL?
    private var oneTime: String = "0"
    var mediaType: MediaType = .image
    var mediaPreviewType: MediaPreview = .send
    var image: UIImage?
    var video: URL?
    let selectedImageRelay = BehaviorRelay<UIImage?>(value: nil)
    var mediaToPreview: String = ""
    var chatFrom: ChatType = .messages
    
    private var onReloadTableViewClosure: (() -> Void) = { }
    private var messages: [MessageModel] = [] {
        didSet {
            onReloadTableViewClosure()
        }
    }
    
    var chatUserInfo: PublishSubject<ChatUserInfo> = .init()
    var endChatStatus: PublishSubject<Bool> = .init()
    var requestChatStatus: PublishSubject<Int> = .init()
    var acceptChat: PublishSubject<ChatUserInfo> = .init()
    var refuseChat: PublishSubject<ChatUserInfo> = .init()
    var deleteChatForEveryone: PublishSubject<BaseResponse> = .init()
    var deleteChatForMe: PublishSubject<BaseResponse> = .init()
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
    
    // MARK: Init
    init(
        chatID: String,
        chatFrom: ChatType
    ) {
        self.chatID = chatID
        self.chatFrom = chatFrom
        super.init()
        self.fetchLastMessages()
        self.fetchMessages()
    }
    
    deinit {
        PusherManager.shared.disconnect()
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
    
    func oneTime(_ oneTime: String) {
        self.oneTime = oneTime
    }
    
    func updateMediaData(_ data: Data?) {
        mediaData = data
    }
    
    func updateVideo(_ videoURL: URL) {
        guard let videoData = try? Data(contentsOf: videoURL) else { return }
        self.mediaData = videoData
    }
    
    func handelTimerChatShowOrHide() -> Bool {
        return false
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
        pusherManager.subscribeToChannel(channelName: "chat-\(chatID)", eventName: "message-sent") { event in
            let jsonString = event.data
            if let responseData: ChatMessagePusherModel = PusherManager.shared.parseJSON(jsonString: jsonString, type: ChatMessagePusherModel.self) {
                print("responseData: \(responseData)")
                var type: MessageType?
                if responseData.type == "text" {
                    type = .text
                } else if responseData.type == "file", responseData.media_type == "image" {
                    type = .image
                } else if responseData.type == "file", responseData.media_type == "sound" {
                    type = .audio
                } else if responseData.type == "file", responseData.media_type == "video" {
                    type = .video
                }
                guard let messageType = type else { return }
                let content = MessageContentModel(createdAt: responseData.created_at?.convertFullDateToTime,
                                                  content: responseData.message,
                                                  path: responseData.file,
                                                  senderId: "\(responseData.user_id ?? 0)",
                                                  type: messageType,
                                                  one_time: responseData.one_time ?? 0, 
                                                  message_id: responseData.message_id)
                let message = MessageModel(SenderID: "\(responseData.user_id ?? 0)",
                                           chatId: "\(responseData.chat_id ?? 0)",
                                           messages: content)
                self.messages.append(message)
            }
        }
    }
}


// MARK: Send message to firebase

extension ChatViewModel {
    func sendMessage(completion: @escaping ((Bool) -> Void)) {
        
        let model = ChatMessageRequestModel(
            chatId: chatID,
            message: messageText,
            type: messageType?.rawValue,
            mediaType: mediaMessageType?.rawValue, 
            oneTime: self.oneTime
        )
    
        let multiPartList = createMultiPartData()
                
        worker.sendMessage(model: model, fileModel: multiPartList).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print("ERROR: \(error)")
                self.error(error.localizedDescription)
                completion(false)
            }
        }).disposed(by: disposeBag)
    }
    
    
    private func createMultiPartData()-> [MultiPartData] {
        guard let mediaData = self.mediaData, messageType == .file else { return [] }
        
        var multiPartList = [MultiPartData]()
        
        switch mediaMessageType {
        case .image:
            let multiPart = MultiPartData(
                keyName: "media",
                fileData: mediaData,
                mimeType: "image/jpeg",
                fileName: "image.jpeg"
            )
            multiPartList = [multiPart]
            
        case .sound:
            let multiPart = MultiPartData(
                keyName: "media",
                fileData: mediaData,
                mimeType: "audio/m4a",
                fileName: "audio.m4a"
            )
            multiPartList = [multiPart]
            
        case .video:
            let multiPart = MultiPartData(
                keyName: "media",
                fileData: mediaData,
                mimeType: "video/mp4",
                fileName: "video.mp4"
            )
            multiPartList = [multiPart]
        default:
            break
        }
        
        return multiPartList
    }
}


// MARK: Fetch last messages

extension ChatViewModel {
     func fetchLastMessages() {
        let requestModel = OneChatRequestModel(chatId: chatID, type: chatFrom.rawValue)
        print("requestModel: \(requestModel)")
        worker.oneChat(model: requestModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                
                print("")
                var items: [MessageModel] = []
                model.data?.data?.forEach({ item in
                    items.append(item.toDomain())
                })
                print("Item: \(items)")
                self.messages = items
                self.messages = self.messages.reversed()
                guard let userInfo = model.chat else { return }
                self.chatUserInfo.onNext(userInfo)
            case .failure(let error):
                print("ERROR: \(error)")
                self.error(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
}

extension OneChatItem {
    func toDomain()-> MessageModel {
        var messageType: MessageType = .text
        if type == "text" {
            messageType = .text
        } else if type == "file", mediaType == "image" {
            messageType = .image
        } else if type == "file", mediaType == "sound" {
            messageType = .audio
        } else if type == "file", mediaType == "video" {
            messageType = .video
        }
        
        let content = MessageContentModel(createdAt: createdAt?.convertFullDateToTime,
                                          content: message,
                                          path: filePath,
                                          senderId: "\(senderID ?? 0)",
                                          type: messageType, 
                                          one_time: one_time ?? 0, 
                                          message_id: id)
        
        let message = MessageModel(SenderID: "\(senderID ?? 0)",
                                   chatId: "\(chatID ?? 0)",
                                   messages: content)
        
        return message
    }
}


//MARK: - Actions on Chat header
extension ChatViewModel {
    func endChat(chatID: Int) {
        worker.endChat(chatID: chatID).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                endChatStatus.onNext(model.status ?? false)
            case .failure(let error):
                print("ERROR: \(error)")
                self.error(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
   
}

//MARK: - send Add request to another
extension ChatViewModel {
    func requestChat(secondUserID: Int) {
        let model = RequestChatRequestModel(
            userId: secondUserID,
            message: "",
            isSpecial: 0,
            type: "friend_request"
        )
        
        print("secondUserID: \(secondUserID)")
        workerLinkMeAPI.requestChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.subscribeRequest(id: data.id ?? 0)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func subscribeRequest(id: Int) {
        pusherManager.subscribeToChannel(channelName: "request-\(id)", eventName: "request-updated") { event in
            let jsonString = event.data
            
            if let responseData: ResponseData = PusherManager.shared.parseJSON(jsonString: jsonString, type: ResponseData.self) {
                let requestId = responseData.request_id
                let status = responseData.status
                self.chatID = "\(requestId ?? 0)"
                self.requestChatStatus.onNext(responseData.status ?? 0)
                print("responseData: \(responseData)")
            }
        }
    }
}

//MARK: - Accept or Ignore friend requeest
extension ChatViewModel {
    func acceptChatRequest() {
        let model = ChatRequestAcceptModel(requestId: Int(chatID))
        worker.acceptChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.acceptChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
    
    func refuseChatRequest() {
        let model = ChatRequestRefuseModel(requestId: Int(chatID))
        worker.refuseChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.refuseChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
}

//MARK: Call API Actions [reportUser, unfriend, deleteForEveryone, deleteForMe]
extension ChatViewModel {
    func deleteChatForEveryone(messageID: Int) {
        let model = DeleteChatForEveryoneMeRequestModel(messageID: messageID)
        worker.deleteChatForEveryone(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.deleteChatForEveryone.onNext(model)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
    
    func deleteChatForMe(messageID: Int) {
        let model = DeleteChatForMeRequestModel(messageID: messageID)
        worker.deleteChatForMe(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.deleteChatForEveryone.onNext(model)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
}
