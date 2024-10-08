//
//  BlockUserVC.swift
//  Link-Me
//
//  Created by Ahmed Eltrass on 23/07/2024.
//

import UIKit
import RxCocoa
import RxSwift

class BlockUserVC: BaseWireFrame<BlockUserViewModel>,NavigationBarDelegate {
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var navigationView: NavigationBarView!
    @IBOutlet private weak var blockUserTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    //MARK: - Variables -
    var user: UnblockUserModel = UnblockUserModel(id: 0, image: "", name: "", description: "")
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        navigationView.configure(with: NavigationBarViewModel(navBarTitle:"BlockUser".localized), and: self)
        viewModel.ViewDidLoad()
        configureTableView()
        viewModel.blockUsersObservable.asObservable()
                   .subscribe(onNext: { [weak self] blockUsers in
                       self?.updateView(for: blockUsers)
                   })
                   .disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    override func bind(viewModel: BlockUserViewModel) {
        setupView()
        configureTableView()
    }
    
    //MARK: - Private func
    private func setupView(){
        navigationView.configure(with: NavigationBarViewModel(navBarTitle:"BlockUser".localized), and: self)
    }
    func navigate(user: UnblockUserModel){
        let vc = coordinator.Main.viewcontroller(for: .unblockUser(parameter: user ))
        if let unblockerAlertVC = vc as? UnBlockerAlert {
               unblockerAlertVC.reloadAfterDismiss = self
           }
        self.present(vc, animated: true)
    }
    func updateView(for tickets: [User]) {
            if tickets.isEmpty {
                emptyView.isHidden = false
                blockUserTableView.isHidden = true
            } else {
                emptyView.isHidden = true
                blockUserTableView.isHidden = false
            }
        }
   
}
extension BlockUserVC {
    private func configureTableView() {
        blockUserTableView.registerNIB(cell: BlockUserCell.self)
        blockUserTableView.separatorStyle = .none
        blockUserTableView.rx.rowHeight.onNext(98)
        subscribeToProducts()
        didSelectTableViewItem()
    }
    
    private func subscribeToProducts() {
        viewModel.blockUsersObservable.bind(to: blockUserTableView.rx.items(cellIdentifier: String(describing: BlockUserCell.self), cellType: BlockUserCell.self)){ (row, item, cell) in
            cell.update(item)
            cell.unblockUser = {[weak self] in
                guard let self else {return}
                print(item)
//                viewModel.setUnBlockUser(userId:item.id ?? 0,view: self.view)
                navigate(user:UnblockUserModel(id: item.id ?? 0 , image: item.imagePath ?? "" , name: item.name ?? "", description: item.bio ?? ""))
            }
        }.disposed(by: disposeBag)
    }
    
    private func didSelectTableViewItem() {
        Observable.zip(blockUserTableView.rx.itemSelected, blockUserTableView.rx.modelSelected(Friendship.self)).subscribe(onNext:{ [weak self] (indexPath, item) in
            
            guard let self = self else { return }
            print("didSelectTableViewItem", item)
        }).disposed(by: disposeBag)
    }
}
extension BlockUserVC: ReloadAfterDismiss {
    func reloadAfter() {
        viewModel.getBlockUser()
    }
    
    
}

