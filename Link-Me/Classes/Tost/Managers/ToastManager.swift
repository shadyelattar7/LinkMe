//
//  ToastManager.swift
//  ToastView
//
//  Created by Elattar on 10/11/20.
//  Copyright © 2020 Shadi Elattar. All rights reserved.
//

import Foundation
import UIKit

enum Postion{
    case top
    case bottom
}

class ToastManager{
    static let shared = ToastManager()
    private var view : UIView = UIView()
    private var message: String = ""
    private var bottomConstraint: NSLayoutConstraint!
    private var topConstraint: NSLayoutConstraint!
    private var toastViews: [ToastView] = []

    private init(){}

    
    func showToast(message: String, view: UIView, postion: Postion, backgroundColor: UIColor, icon: UIImage = UIImage()){
        let toastView: ToastView? = ToastView()
        toastViews.forEach ({hideToast(toastView: $0)})
        self.view = view
        self.message = message
        //create actual Toast View and add it to screen
        createToastWithInitialPos(toastView: toastView, color: backgroundColor, icon: icon, postion: postion)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hideToast(toastView: toastView)
        }
        
        
    }
    
    private func createToastWithInitialPos(toastView: ToastView?, color: UIColor, icon: UIImage, postion: Postion){
        guard let toastView = toastView else {return}
        
        toastView.mtLabel.text = self.message
        toastView.layer.cornerRadius = 10
        toastView.layer.masksToBounds = true
        toastView.contantView.backgroundColor = color
   
        if icon.size.width == 0{
            toastView.icon_iv.isHidden = true
        }else{
            let imageWidth = toastView.icon_iv.frame.size.width
//            print("ImageWidth: \(imageWidth)")
            if toastView.mtLabel.numberOfVisibleLines > 2 {
                toastView.labelLeading.constant = (55)
            } 
//            print(toastView.mtLabel.numberOfVisibleLines)
            toastView.icon_iv.image = icon
        }
        
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        
        switch postion{
        case .top:
            topConstraint = toastView.topAnchor.constraint(equalTo: guide.topAnchor, constant: -100)
            topConstraint.isActive = true
        case .bottom:
            bottomConstraint = toastView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 100)
            bottomConstraint.isActive = true
        }
        
      

        toastView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        toastView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        toastView.heightAnchor.constraint(equalToConstant: toastView.toastHeight).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.layoutIfNeeded()
        animateToast(postion: postion)
        
    }
    
    private func animateToast(postion: Postion){
        
        
        switch postion{
            
        case .top:
            topConstraint.constant = 24
        case .bottom:
            if KeyboardStateManager.shared.isVisible{
                bottomConstraint.constant = -KeyboardStateManager.shared.keyboardOffset - 8
            }else{
                bottomConstraint.constant = -20
            }
        }
    
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideToast(toastView: ToastView?){
        UIView.animate(withDuration: 1, animations: {
            toastView?.alpha = 0
        }) { (_) in
            toastView?.removeFromSuperview()
        }
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
