//
//  TestPremuimViewController.swift
//  Link-Me
//
//  Created by Al-attar on 29/09/2023.
//

import UIKit
import StoreKit

class TestPremuimViewController: BaseWireFrame<TestPremuimViewModel>, UITableViewDelegate, UITableViewDataSource,SKProductsRequestDelegate, SKPaymentTransactionObserver {
 
    

    @IBOutlet weak var sdhjTableBiew: UITableView!
    var models = [SKProduct]()
    
    override func bind(viewModel: TestPremuimViewModel) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)

        sdhjTableBiew.registerNIB(cell: PurchasesCell.self)
        sdhjTableBiew.delegate = self
        sdhjTableBiew.dataSource = self
    
        fetchProducts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as PurchasesCell
        let product = models[indexPath.row]
        cell.title_lbl.text = "\(product.localizedTitle): \(product.localizedDescription) - \(product.priceLocale.currencySymbol ?? "$")\(product.price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
    
    enum Product: String ,CaseIterable {
       case month = "lm_20_1m"
       case week = "lm_499_1w"
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
            self.sdhjTableBiew.reloadData()
        }
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //
        transactions.forEach {
            switch $0.transactionState{
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased, Transactions ID: \($0.transactionIdentifier)")
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
    
 
}
