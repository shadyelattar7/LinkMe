//
//  RemoveAccountReasonVC.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import UIKit

class RemoveAccountReasonVC: BaseWireFrame<RemoveAccountReasonViewModel>, NavigationBarDelegate,UIScrollViewDelegate {
   
    //MARK: - @IBOutlet
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Bind -
    
    override func bind(viewModel: RemoveAccountReasonViewModel) {
        viewModel.viewDidload(view: self.view)
        setupView()
        reasonRemoveTableViewSetup()
    }
    
    
    //MARK: - Private func -
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Remove Account"), and: self)
    }
    
    private func reasonRemoveTableViewSetup(){
        
        tableView.registerNIB(cell: RemoveReasonCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(80)
        viewModel.reasons.bind(to: tableView.rx.items(cellIdentifier: String(describing: RemoveReasonCell.self), cellType: RemoveReasonCell.self)){ (row,item,cell) in
            cell.title_lbl.text = item.title_en
        }.disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else {return}
            let reason = self.viewModel.reasons.value[indexPath.row]
            if indexPath.row == self.viewModel.reasons.value.count - 1{
                print("Other")
                self.coordinator.Main.navigate(for: .RemoveAccount(reason: reason.title_en ?? ""))
            }else{
                self.coordinator.Main.navigate(for: .DeleteAccount(reason: reason.title_en ?? ""),navigtorTypes: .present(style: .overFullScreen))
            }
            
        }.disposed(by: disposeBag)
        
    }

    
    
    //MARK: - Actions -
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
}
