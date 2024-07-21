//
//  ChatViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import Foundation
import RxSwift


enum ChatType: String{
    case home = "home"
    case search = "search"
    case messages = "message"
}

class ChatViewModel: BaseViewModel {
    
    // MARK:  proprites
    
    private let pusherManager = PusherManager.shared
    private var chatID: String
    private let worker: ChatWorkerProtocol = ChatWorker()
    private let disposeBag = DisposeBag()
    private var error: (String) -> Void = { _ in }
    private var messageType: ChatMessageType?
    private var mediaMessageType: ChatMessageMediaType?
    private var messageText: String?
    private var mediaData: Data?
    
    var chatFrom: ChatType = .messages

    private var onReloadTableViewClosure: (() -> Void) = { }
    private var messages: [MessageModel] = [] {
        didSet {
            onReloadTableViewClosure()
        }
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
    
    func updateMediaData(_ data: Data?) {
        mediaData = data
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
                var type: MessageType?
                if responseData.type == "text" {
                    type = .text
                } else if responseData.type == "file", responseData.media_type == "image" {
                    type = .image
                } else if responseData.type == "file", responseData.media_type == "sound" {
                    type = .audio
                }
                guard let messageType = type else { return }
                let content = MessageContentModel(createdAt: responseData.created_at?.convertFullDateToTime,
                                                  content: responseData.message,
                                                  path: responseData.file,
                                                  senderId: "\(responseData.user_id ?? 0)",
                                                  type: messageType)
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
    func sendMessage() {
        
        let model = ChatMessageRequestModel(chatId: chatID, message: messageText, type: messageType?.rawValue, mediaType: mediaMessageType?.rawValue)
        
        let multiPartList = createMultiPartData()
        
        worker.sendMessage(model: model, fileModel: multiPartList).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(_):
                break
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


// MARK: Fetch last messages

extension ChatViewModel {
    private func fetchLastMessages() {
        print("chatFrom.rawValue: \(chatFrom.rawValue)")
        let requestModel = OneChatRequestModel(chatId: chatID, type: chatFrom.rawValue)
        worker.oneChat(model: requestModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                var items: [MessageModel] = []
                model.data?.data?.forEach({ item in
                    items.append(item.toDomain())
                })
                self.messages = items
                self.messages = self.messages.reversed()
            case .failure(let error):
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
        }
        
        let content = MessageContentModel(createdAt: createdAt?.convertFullDateToTime,
                                          content: message,
                                          path: filePath,
                                          senderId: "\(senderID ?? 0)",
                                          type: messageType)
        
        let message = MessageModel(SenderID: "\(senderID ?? 0)",
                                   chatId: "\(chatID ?? 0)",
                                   messages: content)
        
        return message
    }
}
