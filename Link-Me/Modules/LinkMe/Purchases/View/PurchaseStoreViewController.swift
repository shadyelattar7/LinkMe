//
//  PurchaseStoreViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/10/2023.
//

import UIKit
import StoreKit

class PurchaseStoreViewController: BaseWireFrame<PurchaseStoreViewModel>, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var headerView: NavigationBarView!
    @IBOutlet private weak var availableDiamondsView: UIView!
    @IBOutlet private weak var diamondView: UIView!
    @IBOutlet private weak var numberOfDiamondLabel: UILabel!
    @IBOutlet private weak var mySubscriptionStackView: UIStackView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var expiredSubscriptionStackView: UIStackView!
    @IBOutlet private weak var expiredSubscriptionLabel: UILabel!
    @IBOutlet private weak var subscriptionButton: UIButton!
    @IBOutlet private weak var diamondsStoreCollectionView: UICollectionView!
    @IBOutlet private weak var heightOfDiamondsStoreCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var starsStoreCollectionView: UICollectionView!
    @IBOutlet private weak var heightOfStarsStoreCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var howItWorkButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    
    //MARK: - var
    var models = [SKProduct]()
    var indexPath: Int = 0
    
    // MARK: - LifeCyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfDiamondsStoreCollectionViewConstraint.constant =
            self.diamondsStoreCollectionView.contentSize.height
            self.heightOfStarsStoreCollectionViewConstraint.constant =
            self.starsStoreCollectionView.contentSize.height
        }
    }
    
    //MARK: - Bind
    
    override func bind(viewModel: PurchaseStoreViewModel) {
        viewModel.getStars(view: self.view)
        viewModel.getDiamonds(view: self.view)
        viewModel.getMyAccountData()
        
        SKPaymentQueue.default().add(self)
        
        fetchProducts()
        
        subscriptions()
        
    }
    
    
    private func subscriptions(){
        viewModel.diamondsStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model {
                self.diamondsStoreCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        viewModel.starsStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model {
                self.starsStoreCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        
        
        viewModel.buyDiamondsStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("supscription Subscribe!! 🚀🚀🚀")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
        
        
        viewModel.buyStarsStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("supscription Subscribe!! 🚀🚀🚀")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
        
        viewModel.myAccountStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                self.numberOfDiamondLabel.text = "\(model.data?.diamonds ?? 0)"
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    enum Product: String ,CaseIterable {
        case diamonds1000 = "Diamonds_1000"
        case diamonds800 = "Diamonds_800"
        case diamonds400 = "Diamonds_400"
        case diamonds200 = "Diamonds_200"
        case diamonds100 = "Diamonds_100"
        case diamonds50 = "Diamonds_50"
        case diamonds7 = "Diamonds_7"
    }
    
    //MARK: - Funcations
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("product: \(response.products)")
            self.models = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState{
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased, Transactions ID: \($0.transactionIdentifier ?? "")")
                let transctionIDIntValue = Int($0.transactionIdentifier ?? "")
                print("transctionIDIntValue: \(transctionIDIntValue ?? 0)")
                viewModel.buyDiamonds(supscription_plan_id:viewModel.diamonds.value[self.indexPath].id ?? 0, transction_id: (transctionIDIntValue ?? 0), view: self.view)
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("did not purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    

    
    private func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    //MARK: - Actions
    
    @IBAction func howItWorkTapped(_ sender: Any) {
        self.coordinator.Main.navigate(for: .aboutStars, navigtorTypes: .present())
    }
    
}

// MARK: - Private Handlers

extension PurchaseStoreViewController: NavigationBarDelegate {
    private func configureUI() {
        headerView.configure(with: NavigationBarViewModel(navBarTitle: "Purchases"), and: self)
        availableDiamondsView.layer.cornerRadius = 8
        diamondView.makeCircleView()
        mySubscriptionStackView.layer.cornerRadius = 8
        linkView.makeCircleView()
        subscriptionButton.layer.cornerRadius = 8
        howItWorkButton.underline()
        privacyButton.underline()
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Handle collection views

extension PurchaseStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        diamondsStoreCollectionView.registerNIB(CardStoreCollectionViewCell.self)
        starsStoreCollectionView.registerNIB(CardStoreCollectionViewCell.self)
        diamondsStoreCollectionView.delegate = self
        diamondsStoreCollectionView.dataSource = self
        starsStoreCollectionView.delegate = self
        starsStoreCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case diamondsStoreCollectionView:
            return viewModel.diamonds.value.count
        default:
            return viewModel.stars.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case diamondsStoreCollectionView:
            let cell = collectionView.dequeue(cell: CardStoreCollectionViewCell.self, for: indexPath)
         //   let diamondsData = viewModel.diamonds.value[indexPath.row]
            cell.countLabel.text = "\(models[indexPath.row].localizedTitle)"
            cell.subLabel.text = "$ \(models[indexPath.row].price)"
            return cell
            
        default:
            let cell = collectionView.dequeue(cell: CardStoreCollectionViewCell.self, for: indexPath)
            cell.applyStarsStore()
            let starsData = viewModel.stars.value[indexPath.row]
            cell.countLabel.text = "\(starsData.hours ?? 0) Hour"
            cell.subLabel.text = "\(starsData.diamonds ?? 0) Diamond"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case diamondsStoreCollectionView:
            print("diamondsStoreCollectionView IndexPath: \(indexPath.row)")
            let payment = SKPayment(product: models[indexPath.row])
            SKPaymentQueue.default().add(payment)
            self.indexPath = indexPath.row
        default:
            print("starsStoreCollectionView IndexPath: \(indexPath.row)")
            viewModel.buyStars(star_price_id: viewModel.stars.value[indexPath.row].id ?? 0, view: self.view)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
