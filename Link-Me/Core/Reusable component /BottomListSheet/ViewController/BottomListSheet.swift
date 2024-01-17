//
//  BottomListSheet.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol BottomListDismissedProtocol: AnyObject {
    func dismiss()
}

class BottomListSheet: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var itemsParentView: UIView!
    @IBOutlet private weak var heightOfItemsViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var handView: UIView!
    @IBOutlet private weak var itemsTableView: UITableView!
    
    // MARK: Properties
    
    weak var delegate: BottomListDismissedProtocol?
    private let viewModel: BottomListSheetViewModel
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: BottomListSheetViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        subscribeToScreenState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openBottomListSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissBottomListSheet()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfItemsViewConstraint.constant = self.itemsTableView.contentSize.height + 48
        }
    }
}

// MARK: Configure UI

extension BottomListSheet {
    private func configureUI() {
        itemsParentView.layer.cornerRadius = 12
        configureHandViewUI()
    }
    private func configureHandViewUI() {
        handView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        handView.layer.cornerRadius = 5
    }
}

// MARK: Fire NotificationCenter

extension BottomListSheet {
    private func openBottomListSheet() {
        NotificationCenter.default.post(name: NSNotification.Name(StaticKeys.pauseSegmentController), object: self, userInfo: nil)
    }
    
    private func dismissBottomListSheet() {
        NotificationCenter.default.post(name: NSNotification.Name(StaticKeys.resumeSegmentController), object: self, userInfo: nil)
    }
}

// MARK: ViewModel Outputs

extension BottomListSheet {
    private func subscribeToScreenState() {
        viewModel.screenStateObserver.subscribe { [weak self] state in
            guard let self = self else { return }
            
            switch state.element {
            case .success:
                self.delegate?.dismiss()
                self.dismiss(animated: true)
                
            case .error(let errorMessage):
                ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
}

// MARK: Configure tableView

extension BottomListSheet {
    private func configureTableView() {
        itemsTableView.register(UINib(nibName: "ItemListTableViewCell",
                                      bundle: nil), forCellReuseIdentifier: "ItemListTableViewCell")
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
}

// MARK: Confirm delegate, dataSource

extension BottomListSheet: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListTableViewCell", for: indexPath) as? ItemListTableViewCell else { return UITableViewCell() }
        
        cell.update(viewModel.getItems(indexPath: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.getItems(indexPath: indexPath) {
        case .deleteStory:
            viewModel.deleteStory(storyID: viewModel.getItemID())
        case .report:
            let vc = coordinator.Main.viewcontroller(for: .ReportStory(storyID: viewModel.getItemID()))
            self.present(vc, animated: true)
        case .deleteChat:
            let vc = coordinator.Main.viewcontroller(for: .deleteChats(chatsID:[viewModel.getItemID()])) as! DeleteChatSheetViewController
            vc.delegate = self
            self.present(vc, animated: true)
        case .blockUser(let userID):
            viewModel.blockUser(userID: userID)
        default:
            break
        }
    }
}


// MARK: Delegate

extension BottomListSheet: SuccessDeleteChatProtocol {
    func reload() {
        self.delegate?.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
}
