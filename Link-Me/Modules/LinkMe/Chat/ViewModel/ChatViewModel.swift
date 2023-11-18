//
//  ChatViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import Foundation



class ChatViewModel: BaseViewModel {
    
    // MARK:  proprites
    
    private var messageType: MessageType?
    private var messageText: String?
    private var imageData: Data?
    private var imagePath: String?
    
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
    func updateMessageType(_ type: MessageType) {
        messageType = type
    }
    
    func updateMessageText(_ text: String?) {
        messageText = text
    }
    
    func updateImageData(_ data: Data?) {
        imageData = data
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
        
        
        messages.append(message1)
        messages.append(message2)
    }
}


// MARK: Send message to firebase

extension ChatViewModel {
    func sendMessage() {
        
        // TODO: - Need to contact with firebase to send message.
        
        /// Just dummy data for testing....
        ///
        guard let message = createMessage() else { return }
        self.messages.append(message)
    }
    
    private func createMessage() -> MessageModel? {
        /// Fetch send id.
        ///
        guard let senderId = UDHelper.fetchUserData?.id else { return nil }
        
        
        /// Current time for createdAt filed.
        ///
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = formatter.string(from: Date())
        
        
        var contentMessage: MessageContentModel?
        
        switch messageType {
        case .text:
            guard messageText != nil else { return nil }
            contentMessage = MessageContentModel(content: messageText, createdAt: date, path: nil, receiverId: nil, senderId: "\(senderId)",type: .text)
            
        case .image:
            guard imagePath != nil else { return nil }
            contentMessage = MessageContentModel(content: nil, createdAt: date, path: imagePath, receiverId: nil, senderId: "\(senderId)",type: .image)
            
        default:
            break
        }
        
        let message = MessageModel(ReceiverID: "", SenderID: "\(senderId)", chatId: "", messages: contentMessage, timeStamp: 0)
       return message
    }
}


// MARK: Upload image

extension ChatViewModel {
    func uploadImageToStorage() {
        // TODO: - Need to upload image to firebase storage.
        
        
        /// Just assume successfully upload image to store and send this as message.
        ///
        self.imagePath = "https://link-me.live/uploads/10-2023/rjiqC94DBy."
        self.sendMessage()
    }
}
