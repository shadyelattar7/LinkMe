//
//  ChatViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit

class ChatViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var headerChatView: HeaderChatView!
    @IBOutlet private weak var sendOptionChatView: SendOptionView!
    @IBOutlet private weak var chatTableView: UITableView!
    
    // MARK: Proprites
    
    private let viewModel: ChatViewModelType
    private let coordinator: Coordinator
    private var selectedImage: UIImage?
    private let audioRecorder = AudioRecorder()
    private var isRecording: Bool = false
    
    // MARK: Init
    
    init(viewModel: ChatViewModelType, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onClickOnBackButton()
        sendOptionChatViewOutputs()
        onChangeAudioFile()
        configureTableView()
        viewModelOutputs()
        audioRecorder.setupAudioRecorder()
    }
}


// MARK: Configure header chat view

extension ChatViewController {
    private func onClickOnBackButton() {
        headerChatView.onClickBackButton { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
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
            self.viewModel.sendMessage()
            
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
                self.viewModel.sendMessage()
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
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.selectedImage = originalImage
        }
        
        dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            /// Update image data.
            ///
            let imageData = self.selectedImage?.jpegData(compressionQuality: 0.3)
            self.viewModel.updateMediaData(imageData)
            self.viewModel.updateMessageType(.file)
            self.viewModel.updateMediaMessageType(.image)
            self.viewModel.sendMessage()
        })
    }
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
            
        case .image:
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
