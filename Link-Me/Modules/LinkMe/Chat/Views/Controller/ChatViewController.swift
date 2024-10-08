//
//  ChatViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit
import MobileCoreServices

class ChatViewController: BaseWireFrame<ChatViewModel>, BottomListDismissedProtocol {
    
    // MARK: Outlets
    
    @IBOutlet private weak var headerChatView: HeaderChatView!
    @IBOutlet private weak var sendOptionChatView: SendOptionView!
    @IBOutlet private weak var secondHeaderChatView: SecondHeaderChatView!
    @IBOutlet private weak var chatTableView: UITableView!
    @IBOutlet weak var heightOfHeader: NSLayoutConstraint!
    
    // MARK: Proprites
    
    //    private let viewModel: ChatViewModelType
    //    private let coordinator: Coordinator
    private var selectedImage: UIImage?
    private let audioRecorder = AudioRecorder()
    private var isRecording: Bool = false
    private var userInfo: ChatUserInfo?
    
    //    // MARK: Init
    //
    //    init(viewModel: ChatViewModelType, coordinator: Coordinator) {
    //        self.viewModel = viewModel
    //        self.coordinator = coordinator
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFriendRequestNotification(_:)), name: .didReceiveFriendRequest, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActiveViewControllerManager.shared.updateCurrentViewController(self)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if ActiveViewControllerManager.shared.currentViewController === self {
            ActiveViewControllerManager.shared.updateCurrentViewController(nil)
        }
        NotificationCenter.default.removeObserver(self, name: .didReceiveFriendRequest, object: nil)
    }
    
    //MARK: - Bind
    override func bind(viewModel: ChatViewModel) {
        onClickOnBackButton()
        sendOptionChatViewOutputs()
        onChangeAudioFile()
        configureTableView()
        viewModelOutputs()
        audioRecorder.setupAudioRecorder()
        onClickOnBackButton2()
        onClickOnMenuButton()
        subscriptionUsersInfo()
        subscriptionChatEnd()
        subscriptionAcceptChat()
        subscriptionRefuseChat()
        subscriptionRequestChatStatus()
        addLongPressToTableView()
        subscriptionDeleteChatForEveryone()
    }
    
    @objc private func handleFriendRequestNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        print("Friend request received: \(userInfo)")
        if let aps = userInfo["aps"] as? [String: Any],
           let isAccepted = aps["is_accepted"] as? Int {
            
            if isAccepted == 1 {
                // Handle the case where the chat is accepted
                print("Chat is accepted.")
                self.headerChatView.isHidden = true
                self.secondHeaderChatView.isHidden = false
                heightOfHeader.constant = 400
                subscriptionUsersInfo()
            } else if isAccepted == 2 {
                // Handle the case where the chat is rejected
                print("Chat is rejected.")
                configureHeaderViewType(.ignoreAddRequest, data: nil)
            } else {
                // Handle any other possible values or invalid cases
                print("Unknown is_accepted value: \(isAccepted)")
                configureHeaderViewType(.acceptOrIgnoreAddRequest, data: nil)
            }
        } else {
            // Handle the case where is_accepted is not found or not an Int
            print("is_accepted key is missing or invalid.")
            
            
        }
        
    }
}

// MARK: - Subscribe
private extension ChatViewController {
    func subscriptionUsersInfo() {
        viewModel.chatUserInfo.subscribe { [weak self] data in
            guard let self = self else { return }
            self.userInfo = data
            handleHeader(data: data)
            handleSecondHeader(with: data)
        }.disposed(by: disposeBag)
    }
    
    func subscriptionChatEnd() {
        viewModel.endChatStatus.subscribe {  [weak self] status in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
    
    func subscriptionRequestChatStatus() {
        viewModel.requestChatStatus.subscribe { [weak self] status in
            guard let self = self else { return }
            switch status.element {
            case 1: //accpet
                break
                //                self.headerChatView.isHidden = true
                //                self.secondHeaderChatView.isHidden = false
                //                heightOfHeader.constant = 320
                //                subscriptionUsersInfo()
            case 2: //reject
                self.configureHeaderViewType(.ignoreAddRequest, data: nil)
            default:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionAcceptChat() {
        viewModel.acceptChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            print("subscriptionAcceptChat: 🟢")
            self.headerChatView.isHidden = true
            self.secondHeaderChatView.isHidden = false
            subscriptionUsersInfo()
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionRefuseChat() {
        viewModel.refuseChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            print("subscriptionAcceptChat: 🛑")
            self.configureHeaderViewType(.beforeSendAddRequest, data: response)
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionDeleteChatForEveryone() {
        viewModel.deleteChatForEveryone.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            
            ToastManager.shared.showToast(message: response.message ?? "", view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.successColor)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                if let presentedVC = self.presentedViewController {
                    presentedVC.dismiss(animated: true) {
                        self.viewModel.fetchLastMessages()
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionDeleteChatForMe() {
        viewModel.deleteChatForMe.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            ToastManager.shared.showToast(message: response.message ?? "", view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.successColor)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                if let presentedVC = self.presentedViewController {
                    presentedVC.dismiss(animated: true) {
                        self.viewModel.fetchLastMessages()
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: Configure header chat view
extension ChatViewController {
    private func handleHeader(data: ChatUserInfo) {
        switch viewModel.chatFrom {
        case .home, .search:
            headerChatView.timerStackView.isHidden = data.expire_at == nil
            
            if let expireAt = data.expire_at, !expireAt.isEmpty {
                headerChatView.startCountdown(expireAt: expireAt)
                heightOfHeader.constant = 285
            } else {
                heightOfHeader.constant = 240
            }
            
            secondHeaderChatView.isHidden = true
            
            configureHeaderViewType(.beforeSendAddRequest, data: data)
            
            if UDHelper.isVistor {
                headerChatView.setOtherPersonName("Unknown")
                headerChatView.setUserImage(image: UIImage(named: "Group 63336") ?? UIImage())
            } else if data.first_user_id == UDHelper.fetchUserData?.id ?? 0 {
                headerChatView.setOtherPersonName(data.second_user?.name ?? "")
                headerChatView.setUserImage(imagePath: data.second_user?.imagePath ?? "")
            }  else {
                headerChatView.setOtherPersonName(data.first_user?.name ?? "")
                headerChatView.setUserImage(imagePath: data.first_user?.imagePath ?? "")
            }
            
        case .messages:
            print("messages")
            headerChatView.timerStackView.isHidden = true
            headerChatView.isHidden = true
            secondHeaderChatView.isHidden = false
        }
    }
    
    private func handleSecondHeader(with data: ChatUserInfo) {
        if data.first_user_id == UDHelper.fetchUserData?.id ?? 0 {
            secondHeaderChatView.userName.text = (data.second_user?.name ?? "")
            secondHeaderChatView.userImage.getImage(imageUrl: data.second_user?.imagePath ?? "")
            secondHeaderChatView.statusTitle.text = data.second_user?.is_online == 0 ?  "Offline" : "Available Now"
            secondHeaderChatView.statusIcon.backgroundColor = data.second_user?.is_online == 0 ? UIColor(hex: "#A8B9B3") : UIColor(hex: "#1ED597")
            print("second Name: \(data.second_user?.name ?? "")")
        } else {
            secondHeaderChatView.userName.text = (data.first_user?.name ?? "")
            secondHeaderChatView.userImage.getImage(imageUrl: data.first_user?.imagePath ?? "")
            secondHeaderChatView.statusTitle.text = data.first_user?.is_online == 0 ?  "Offline" : "Available Now"
            secondHeaderChatView.statusIcon.backgroundColor = data.first_user?.is_online == 0 ? UIColor(hex: "#A8B9B3") : UIColor(hex: "#1ED597")
            print("first Name: \(data.first_user?.name ?? "")")
        }
    }
    
    private func configureHeaderViewType(_ type: HeaderViewType, data: ChatUserInfo?) {
        headerChatView.setType(type)
        
        switch type {
        case .beforeSendAddRequest:
            headerChatView.onFirstButtonAction { [weak self] in
                guard let self = self else { return }
                if UDHelper.isVistor {
                    QuickAlert.showWith(in: self, coordentor: self.coordinator)
                } else {
                    if data?.first_user_id == UDHelper.fetchUserData?.id ?? 0 {
                        self.viewModel.requestChat(secondUserID: data?.second_user_id ?? 0)
                        print("Add: \(data?.second_user_id ?? 0)")
                    } else {
                        self.viewModel.requestChat(secondUserID: data?.first_user_id ?? 0)
                        print("Add: \(data?.first_user_id ?? 0)")
                    }
                }
            }
            headerChatView.onSecondButtonAction { [weak self] in
                print("End chat")
                guard let self = self else { return }
                self.viewModel.endChat(chatID: data?.id ?? 0)
            }
        case .acceptOrIgnoreAddRequest:
            headerChatView.onFirstButtonAction { [weak self] in
                guard let self = self else { return }
                print("accpet")
                self.viewModel.acceptChatRequest()
            }
            
            headerChatView.onSecondButtonAction { [weak self] in
                guard let self = self else { return }
                print("Ignore")
                self.viewModel.refuseChatRequest()
            }
            
        case .ignoreAddRequest:
            headerChatView.onSecondButtonAction { [weak self] in
                print("end chat")
                guard let self = self else { return }
                self.viewModel.endChat(chatID: data?.id ?? 0)
            }
        default:
            break
        }
    }
    
    private func onClickOnBackButton() {
        headerChatView.onClickBackButton { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    
    ///Second Header
    private func onClickOnBackButton2() {
        secondHeaderChatView.onBackClick = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func onClickOnMenuButton() {
        secondHeaderChatView.onMenuClick = { [weak self] in
            guard let self = self else { return }
            print("open Menu")
            let vc: BottomListSheet = coordinator.Main.viewcontroller(
                for: .BottomListItem(
                    listItems: [
                        .addFriend,
                        .reportUser,
                        .blockUserInChat(userID: self.userInfo?.first_user?.id ?? 0)
                    ],itemID: 0
                )
            ) as! BottomListSheet
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    func dismiss() {
        print("124")
    }
    
}


// MARK: Configure Send option chat view

extension ChatViewController {
    private func sendOptionChatViewOutputs() {
        onChangeChatText()
        onClickAddButton()
        onClickCameraButton()
        onClickMicButton()
    }
    
    private func onChangeChatText() {
        sendOptionChatView.onChange { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateMessageText(text)
        }
    }
    
    private func onClickAddButton() {
        sendOptionChatView.onClickAdd { [weak self] in
            guard let self = self else { return }
            
            /// Send message to firebase and message type.
            ///
            self.viewModel.updateMessageType(.text)
            self.viewModel.sendMessage { _ in }
            
            /// Empty again text message to prepare it for next message.
            ///
            self.viewModel.updateMessageText(nil)
            self.sendOptionChatView.makeTextFieldEmpty()
        }
    }
    
    private func onClickCameraButton() {
        sendOptionChatView.onClickCamera { [weak self] in
            guard let self = self else { return }
            self.openGallery()
        }
    }
    
    private func onClickMicButton() {
        sendOptionChatView.onClickMic { [weak self] in
            guard let self = self else { return }
            if self.isRecording {
                self.audioRecorder.stopRecording()
                self.sendOptionChatView.stopRecored()
                self.isRecording = false
                
            } else {
                self.audioRecorder.startRecording()
                self.sendOptionChatView.startRecored()
                self.isRecording = true
            }
        }
    }
}


// MARK: Configure audio

extension ChatViewController {
    private func onChangeAudioFile() {
        audioRecorder.onChangeAudioFileUrl = { [weak self] url in
            guard let self = self, let url = url else { return }
            
            do {
                let data = try Data(contentsOf: url)
                self.viewModel.updateMediaData(data)
                self.viewModel.updateMessageType(.file)
                self.viewModel.updateMediaMessageType(.sound)
                self.viewModel.sendMessage { _ in }
            } catch let error {
                print("error when get data form audio url", error)
            }
        }
    }
}


// MARK: Configure Image

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private func openGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType == kUTTypeImage as String {
                // Handle selected image
                if let image = info[.originalImage] as? UIImage {
                    // Do something with the selected image
                    self.viewModel.mediaPreviewType = .send
                    self.viewModel.mediaType = .image
                    self.viewModel.selectedImageRelay.accept(image)
                    self.coordinator.Main.navigate(for: .ImagePreview(viewModel: self.viewModel))
                }
            } else if mediaType == kUTTypeMovie as String {
                // Handle selected video
                if let videoURL = info[.mediaURL] as? URL {
                    // Do something with the selected video URL
                    self.viewModel.mediaPreviewType = .send
                    self.viewModel.mediaType = .video
                    self.viewModel.video = videoURL
                    self.coordinator.Main.navigate(for: .ImagePreview(viewModel: self.viewModel))
                }
            }
        }
        
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        if let editedImage = info[.editedImage] as? UIImage {
    //            self.selectedImage = editedImage
    //        } else if let originalImage = info[.originalImage] as? UIImage {
    //            self.selectedImage = originalImage
    //        }
    //
    //        dismiss(animated: true, completion: { [weak self] in
    //            guard let self = self else { return }
    //            /// Update image data.
    //            ///
    //            let imageData = self.selectedImage?.jpegData(compressionQuality: 0.3)
    //            self.viewModel.updateMediaData(imageData)
    //            self.viewModel.updateMessageType(.file)
    //            self.viewModel.updateMediaMessageType(.image)
    //            self.viewModel.sendMessage()
    //        })
    //    }
}

// MARK: Configure table view

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.registerNIB(cell: TextMessageTableViewCell.self)
        chatTableView.registerNIB(cell: ImageMessageTableViewCell.self)
        chatTableView.registerNIB(cell: AudioMessageTableViewCell.self)
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.chatTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.getItemCell(indexPath: indexPath).messages?.type {
        case .text:
            let cell = tableView.dequeue() as TextMessageTableViewCell
            cell.update(viewModel.getItemCell(indexPath: indexPath))
            return cell
            
        case .image, .video:
            let cell = tableView.dequeue() as ImageMessageTableViewCell
            cell.update(viewModel.getItemCell(indexPath: indexPath))
            return cell
            
        case .audio:
            let cell = tableView.dequeue() as AudioMessageTableViewCell
            cell.update(viewModel.getItemCell(indexPath: indexPath))
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.getItemCell(indexPath: indexPath).messages?.type {
        case .image:
            self.viewModel.mediaPreviewType = .preview
            viewModel.mediaType = .image
            self.viewModel.mediaToPreview = viewModel.getItemCell(indexPath: indexPath).messages?.path ?? ""
            self.coordinator.Main.navigate(for: .ImagePreview(viewModel: self.viewModel))
        case .video:
            self.viewModel.mediaPreviewType = .preview
            self.viewModel.mediaToPreview = viewModel.getItemCell(indexPath: indexPath).messages?.path ?? ""
            self.coordinator.Main.navigate(for: .ImagePreview(viewModel: self.viewModel))
            viewModel.mediaType = .video
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: ViewModel outputs

extension ChatViewController {
    func viewModelOutputs() {
        onReloadTableView()
        onChangeError()
    }
    
    private func onReloadTableView() {
        viewModel.onReloadTableView { [weak self] in
            guard let self = self else { return }
            if self.viewModel.numberOfCells > 0 {
                let lastIndex = IndexPath(row: self.viewModel.numberOfCells - 1, section: 0)
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
            } else {
                self.reloadTableView()
            }
        }
    }
    
    private func onChangeError() {
        viewModel.onChangeError { [weak self] errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
            }
        }
    }
}

extension Notification.Name {
    static let didReceiveFriendRequest = Notification.Name("didReceiveFriendRequest")
}


// MARK: Add long press to table view to present bottom sheet
extension ChatViewController {
    private func addLongPressToTableView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        chatTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: chatTableView)
            if let indexPath = chatTableView.indexPathForRow(at: touchPoint) {
                
                let vc: BottomListSheet
                let messageID = viewModel.getItemCell(indexPath: indexPath).messages?.message_id ?? 0
                
                print("messageID: \(messageID)")
                
                if userInfo?.first_user_id == UDHelper.fetchUserData?.id ?? 0 {
                    print("Add: \(userInfo?.second_user_id ?? 0)")
                    
                    vc = coordinator.Main.viewcontroller(for: .BottomListItem(listItems: [.deleteForEveryone(messageID: messageID), .deleteForMe(messageID: messageID)], itemID: 0)) as! BottomListSheet
                } else {
                    print("Add: \(userInfo?.first_user_id ?? 0)")
                    
                    vc = coordinator.Main.viewcontroller(for: .BottomListItem(listItems: [.deleteForEveryone(messageID: messageID)], itemID: 0)) as! BottomListSheet
                }
                
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
}

// MARK: Add actions bottom sheet
extension ChatViewController {
    func deleteForMe(messageID: Int) {
        print("delete For Me \(messageID)")
        self.viewModel.deleteChatForMe(messageID: messageID)
    }
    
    func deleteForEveryone(messageID: Int) {
        print("delete For Everyone \(messageID)")
        self.viewModel.deleteChatForEveryone(messageID: messageID)
    }
    
    func unfriend() {
        print("unfriend")
    }
    
    func addFriend() {
        print("add Friend")
        if UDHelper.isVistor {
            QuickAlert.showWith(in: self, coordentor: self.coordinator)
        } else {
            if userInfo?.first_user_id == UDHelper.fetchUserData?.id ?? 0 {
                self.viewModel.requestChat(secondUserID: userInfo?.second_user_id ?? 0)
                print("Add: \(userInfo?.second_user_id ?? 0)")
            } else {
                self.viewModel.requestChat(secondUserID: userInfo?.first_user_id ?? 0)
                print("Add: \(userInfo?.first_user_id ?? 0)")
            }
        }
    }
    
    func reportUser() {
        print("report User")
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) {
                let vc = self.coordinator.Main.viewcontroller(for: .ReportStory(friendID: self.userInfo?.first_user?.id ?? 0, reportFrom: .chat))
                self.present(vc, animated: true)
            }
        } else {
            let vc = coordinator.Main.viewcontroller(for: .ReportStory(friendID: self.userInfo?.first_user?.id ?? 0, reportFrom: .chat))
            self.present(vc, animated: true)
        }
    }
    
    func blockUserInChat() {
        print("block User")
    }
}
