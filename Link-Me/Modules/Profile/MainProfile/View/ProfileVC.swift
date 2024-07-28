//
//  ProfileVC.swift
//  Link-Me
//
//  Created by Al-attar on 14/06/2023.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileVC: BaseWireFrame<ProfileViewModel>, UIScrollViewDelegate {

    //MARK: - @IBOutlet
    @IBOutlet weak var profileImgView: UserPhotoProfileView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var mail_lbl: UILabel!
    @IBOutlet weak var bio_lbl: UILabel!
    @IBOutlet weak var links_lbl: UILabel!
    @IBOutlet weak var followers_lbl: UILabel!
    @IBOutlet weak var like_lbl: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var tableHeightView: NSLayoutConstraint!
    @IBOutlet weak var profileIsCompleteView: UIView!
    
    
    //MARK: - Variables -
    
    
    //MARK: - Life Cycle -
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.ViewDidLoad()
        subscriptions()
    }
    
    
    //MARK: - Bind
    override func bind(viewModel: ProfileViewModel) {
        settingTableviewSetup()
        
    }

    //MARK: - Private func
    
    private func SetupView(){
        
        UDHelper.isCompleteProfile = false
        
        name_lbl.text =  UDHelper.fetchUserData?.name ?? ""
        mail_lbl.text = UDHelper.fetchUserData?.email ?? ""
        bio_lbl.text = UDHelper.fetchUserData?.bio ?? "No Bio"
        followers_lbl.text = "\(UDHelper.fetchUserData?.is_following ?? 0)"
        like_lbl.text = "\(UDHelper.fetchUserData?.likes ?? 0)"
        links_lbl.text = "\(UDHelper.fetchUserData?.links ?? 0)"
        if UDHelper.fetchUserData?.is_profile_completed == 0{
            if UDHelper.isVistor {
                profileIsCompleteView.isHidden = true
                profileImgView.configure(with: UserPhotoProfileViewViewModel(userPhoto: UDHelper.fetchUserData?.imagePath ?? "", precntage: 50, radiusCircular: 45), precntage: .half)
            } else {
                profileIsCompleteView.isHidden = false
                profileImgView.configure(with: UserPhotoProfileViewViewModel(userPhoto: UDHelper.fetchUserData?.imagePath ?? "", precntage: 50, radiusCircular: 45), precntage: .half)
            }
        }else{
            profileIsCompleteView.isHidden = true
            profileImgView.configure(with: UserPhotoProfileViewViewModel(userPhoto: UDHelper.fetchUserData?.imagePath ?? "", precntage: 100, radiusCircular: 45), precntage: .complete)
        }
    }
    
    private func subscriptions(){
        viewModel.myAccountStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                self.SetupView()
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    private func settingTableviewSetup(){
        settingTableView.registerNIB(cell: SettingCell.self)
        
        settingTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.settingData.bind(to: settingTableView.rx.items(cellIdentifier: String(describing: SettingCell.self), cellType: SettingCell.self)){ (row,item,cell) in
            cell.configure(data: item)
        }.disposed(by: disposeBag)
        
        
        tableHeightView.constant = settingTableView.contentSize.height
        self.view.layoutIfNeeded()
        
        
        print("tableHeightView: \(tableHeightView.constant)")
        
        settingTableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath.element else {return}

            print("indexPath: \(indexPath.row)")
            
            switch indexPath.row{
            case 0: //Settings
                self.coordinator.Main.navigate(for: .Settings)
            case 1: //Edit Profile
                if UDHelper.isVistor {
                    QuickAlert.showWith(in: self, coordentor: self.coordinator)
                }
                self.coordinator.Main.navigate(for: .EditProfile)
            case 2: //Share App
//                if UDHelper.isVistor {
//                    QuickAlert.showWith(in: self, coordentor: self.coordinator)
//                }
//                self.coordinator.Main.navigate(for: .EditProfile)
                 shareLink(shareLink: "https://www.youtube.com")
            case 3: //Get All Feature
                if UDHelper.isVistor {
                    QuickAlert.showWith(in: self, coordentor: self.coordinator)
                }
                self.coordinator.Main.navigate(for: .purchases)
            default:
                self.coordinator.Main.navigate(for: .EditProfile)
            }
        }.disposed(by: disposeBag)

    }
    
    //MARK: - Actions
    
    @IBAction func completeProfileTapped(_ sender: Any) {
        self.coordinator.Main.navigate(for: .CompleteProfile,navigtorTypes: .present())
    }
    private func shareLink(shareLink: String) {
            let activityViewController = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
            
            // Present the activity view controller
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    
}
