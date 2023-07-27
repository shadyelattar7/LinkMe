//
//  Indicator.swift
//  test app 2
//
//  Created by Ahmed on 2/10/21.
//

import Foundation
import UIKit


/// loading class controller
class Support {
    
    fileprivate func getTopViewController(scope: (_ topVC: UIViewController) -> Void){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            scope(topController)
        }
    }
}


//MARK: - loading section
/// laoding controller
class Loading: Support{
    
    /// static inistance
    static let shared = Loading()
    
    private override init() {}
    
    func showLoading() {
        DispatchQueue.main.async {
            super.getTopViewController { topVC in
                if !LoadingManager.shared.isLoading{
                    LoadingManager.shared.showProgressView(on: topVC.view)
                }
            }
        }
    }
    
    /// hide loading
    func hideProgressView() {
        getTopViewController { topVC in
            LoadingManager.shared.hideProgressView()
        }
    }
    
    /// create loading view to use it in image loading
    /// - Returns: return loading indicator
    func createActivityIndicator() -> UIActivityIndicatorView{
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        activityView.startAnimating()
        return activityView
    }
}


//MARK: - connection section
/// no connection view alert
class connectionAlert: Support {
    
    /// shared inistance of connectionAlert class
    static var shared: connectionAlert{
        let inistance = connectionAlert()
        return inistance
    }
    
    private override init() {}
    
    /// show no internet view
//    func showNetworkAlert() {
//        Loading.shared.hideProgressView()
//        DispatchQueue.main.async {
//            self.getTopViewController { topVC in
//                let noInternet = ViewControllers.NoInternetVC.instantiate(from: .SupportST) as! NoInternetVC
//                if let _ = topVC as? NoInternetVC{
//                    return
//                }
//                topVC.present(noInternet, animated: true, completion: nil)
//            }
//        }
//    }
    
    /// hide no internet view
//    func hideNetworkAlert() {
//        getTopViewController { topVC in
//            if let _ = topVC as? NoInternetVC{
//                topVC.dismiss(animated: false, completion: nil)
//            }
//        }
//    }
}
