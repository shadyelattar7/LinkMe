//
//  GoPremiumVC.swift
//  Link-Me
//
//  Created by Al-attar on 23/09/2023.
//

import UIKit
import StoreKit

class GoPremiumVC: BaseWireFrame<GoPremiumViewModel>, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    //MARK: - @IBOutlet
    @IBOutlet weak var subscripationCollectionView: UICollectionView!
    @IBOutlet weak var subscripeButton: MainButton!
    
    //MARK: - var
    var models = [SKProduct]()
    var indexPath: Int = 0
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Bind
    override func bind(viewModel: GoPremiumViewModel) {
        SKPaymentQueue.default().add(self)

        subscripationCollectionView.registerNIB(SubscriptionCell.self)
        
        subscripationCollectionView.delegate = self
        subscripationCollectionView.dataSource = self
        
        fetchProducts()
    
        subscriptions()
    }
    
    enum Product: String ,CaseIterable {
       case month = "lm_20_1m"
       case week = "lm_499_1w"
    }
    
    //MARK: - Private Func
    
    private func subscriptions(){
        viewModel.supscriptionSubscribeStatus.subscribe { [weak self] model in
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
    }
    
    private func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("product: \(response.products)")
            self.models = response.products
            self.subscripationCollectionView.reloadData()
            
            let product = self.models[0]
            self.subscripeButton.MainBtn.setTitle("SUBSCRIPE FOR\(product.priceLocale.currencySymbol ?? "$")\(product.price)", for: .normal)
            self.subscripeButton.MainBtn.addTarget(self, action: #selector(self.subscripeTapped), for: .touchUpInside)
            
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.subscripationCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
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
                viewModel.supscriptionSubscribe(supscription_plan_id: self.indexPath + 1, transction_id: (transctionIDIntValue ?? 0), view: self.view)
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
    
    //MARK: - Action
    @IBAction func closeTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func subscripeTapped(){
        let payment = SKPayment(product: models[self.indexPath])
        SKPaymentQueue.default().add(payment)

    }
    
}

//MARK: - collection view configuration

extension GoPremiumVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = models[indexPath.row]
        let cell = collectionView.dequeue(cell: SubscriptionCell.self, for: indexPath)
        cell.pricelabel.text = "\(product.priceLocale.currencySymbol ?? "$")\(product.price)"
        
        switch indexPath.row{
        case 0:
            cell.duriationLabel.text = "/Month"
            cell.billedDuriationLabel.text = "Billed monthly"
        case 1:
            cell.duriationLabel.text = "/Week"
            cell.billedDuriationLabel.text = "Billed annually"
        default:
            cell.duriationLabel.text = "/Month"
            cell.billedDuriationLabel.text = "Billed monthly"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath.row
        
        let product = models[indexPath.row]
        subscripeButton.MainBtn.setTitle("SUBSCRIPE FOR\(product.priceLocale.currencySymbol ?? "$")\(product.price)", for: .normal)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: 175)

     }
    
}
