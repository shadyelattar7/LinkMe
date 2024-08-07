//
//  OtherSettingsVC.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import UIKit

class OtherSettingsVC: BaseWireFrame<OtherSettingsViewModel>,NavigationBarDelegate,UIScrollViewDelegate {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    //MARK: - Bind
    
    override func bind(viewModel: OtherSettingsViewModel) {
        setupView()
        setupTableView()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Other Settings".localized), and: self)
    }
    
    private func setupTableView(){
        settingTableView.registerNIB(cell: OtherSeeCell.self)
        
        settingTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.settingData.bind(to: settingTableView.rx.items(cellIdentifier: String(describing: OtherSeeCell.self), cellType: OtherSeeCell.self)){ [weak self] (row,item,cell) in
            guard let self = self else {return}
           
            cell.title_lbl.text = item.title
            switch row {
            case 0:
                cell.optionsToggle.setOn(UDHelper.fetchUserData?.can_see_followers == 1 ? true : false, animated: true)
            case 1:
                cell.optionsToggle.setOn(UDHelper.fetchUserData?.can_see_likes == 1 ? true : false, animated: true)
            case 2:
                cell.optionsToggle.setOn(UDHelper.fetchUserData?.can_see_links == 1 ? true : false, animated: true)
            default:
                print("")
            }
            cell.toggleOptions = { [weak self] toggle in
                guard let self = self else {return}
                switch row {
                case 0:
                    if UDHelper.fetchUserData?.can_see_followers == 0 {
                        viewModel.showAndHid(type: "followers", view:self.view)
                           
                    } else {
                        if UDHelper.isVistor {
                            viewModel.showAndHid(type: "followers", view:self.view)
                        }else {
                            self.coordinator.Main.navigate(for: .FeaturesPremium,navigtorTypes: .present())
                           
                        }
                    }
                case 1:
                    viewModel.showAndHid(type: "likes", view:self.view)
                case 2:
                    viewModel.showAndHid(type: "links", view:self.view)
                default:
                    print("")
                }
               print("Toggle: \(toggle)")
            }
            
            
        }.disposed(by: disposeBag)
        
        
        heightTableView.constant = settingTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
     
    
}
