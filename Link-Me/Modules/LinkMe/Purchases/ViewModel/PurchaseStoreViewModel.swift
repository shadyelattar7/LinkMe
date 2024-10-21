//
//  PurchaseStoreViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 27/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol PurchasesVInputs {
    
}


//MARK: - ViewController <- ViewModel

protocol PurchasesOutputs {
    // var loginStatus: PublishSubject<BaseResponseGen<User>> {get set}
    
}

class PurchaseStoreViewModel: BaseViewModel, PurchasesVInputs,PurchasesOutputs{
 
    let myAccount: MyAccountWorkerProtocol
    let PurchaseStore: PurchaseStoreAPIProtocol
    let disposedBag = DisposeBag()
    
    var diamonds: BehaviorRelay<[DiamondsModel]> = .init(value: [])
    var stars: BehaviorRelay<[StarsModel]> = .init(value: [])
    var diamondsStatus: PublishSubject<Bool> = .init()
    var starsStatus: PublishSubject<Bool> = .init()
    var hideNav: Bool?
    init(PurchaseStore: PurchaseStoreAPIProtocol,myAccount: MyAccountWorkerProtocol,hideNav: Bool? = false ) {
        self.PurchaseStore = PurchaseStore
        self.myAccount = myAccount
        self.hideNav = hideNav 
    }
    
    //MARK: - Output
    var buyDiamondsStatus: PublishSubject<BaseResponse> = .init()
    var buyStarsStatus: PublishSubject<BaseResponse> = .init()
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> = .init()
    
}

//MARK: - Call API

extension PurchaseStoreViewModel {
    
    func getDiamonds(view: UIView){
        PurchaseStore.getDiamonds().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.diamonds.accept(model.data ?? [])
                self.diamondsStatus.onNext(model.status ?? false)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    func getStars(view: UIView){
        PurchaseStore.getStars().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                print("Model: \(model)")
                self.stars.accept(model.data ?? [])
                self.starsStatus.onNext(model.status ?? false)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    func buyDiamonds(supscription_plan_id: Int,transction_id: Int, view: UIView){
        PurchaseStore.buyDiamonds(model: BuyDiamondsRequestModel(product_id: supscription_plan_id, transaction_id: transction_id, paid_by: "ios")).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                 ToastManager.shared.showToast(message: "You Subscribed Successfully", view: view, postion: .top, backgroundColor: .systemGreen)
                self.buyDiamondsStatus.onNext(model)
                print("Model: \(model)")
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
            }
        }).disposed(by: disposedBag)
    }
    
    func buyStars(star_price_id: Int, view: UIView){
        PurchaseStore.buyStars(model: BuyStarsRequestModel(star_price_id: star_price_id)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .systemGreen)
                self.buyStarsStatus.onNext(model)
                print("Model: \(model)")
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
            }
        }).disposed(by: disposedBag)
    }
    
    
    func getMyAccountData(){
        myAccount.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
                self.myAccountStatus.onNext(model)
            case .failure(let error):
                _ = error.userInfo["NSLocalizedDescription"] as! String
                print("ERROR IN MY ACCOUNT ❌❌❌: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
