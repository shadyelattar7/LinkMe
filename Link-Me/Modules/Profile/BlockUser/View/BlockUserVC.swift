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
    
    
    //MARK: - Variables -
    var user: UnblockUserModel = UnblockUserModel(id: 0, image: "", name: "", description: "")
    
    //MARK: - Life Cycle -
    override func viewWillAppear(_ animated: Bool) {
        viewModel.ViewDidLoad()
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
        self.present(vc, animated: true)
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
        Observable.zip(blockUserTableView.rx.itemSelected, blockUserTableView.rx.modelSelected(FriendModel.self)).subscribe(onNext:{ [weak self] (indexPath, item) in
            
            guard let self = self else { return }
            print("didSelectTableViewItem", item)
        }).disposed(by: disposeBag)
    }
}

