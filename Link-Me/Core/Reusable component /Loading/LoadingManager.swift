

import Foundation
import UIKit

class LoadingManager {
    static let shared = LoadingManager()
    
    private (set) var isLoading: Bool = false
    
    private var containerView: UIView = {
        let view = UIView()
        view.frame = UIWindow(frame: UIScreen.main.bounds).frame
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return view
    }()
    
    private var progressView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.center = UIWindow(frame: UIScreen.main.bounds).center
        view.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 0.7)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        return activityIndicator
    }()
    
    func showProgressView(on view: UIView) {
        isLoading = true
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        activityIndicator.startAnimating()
    }
    
    func hideProgressView() {
        isLoading = false
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
