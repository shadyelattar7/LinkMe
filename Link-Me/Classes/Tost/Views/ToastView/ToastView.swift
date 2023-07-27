//
//  ToastView.swift
//  ToastView
//
//  Created by Elattar on 10/11/20.
//  Copyright © 2020 Shadi Elattar. All rights reserved.
//

import UIKit

class ToastView: UIView {

    @IBOutlet var contantView: UIView!
    @IBOutlet weak var mtLabel: UILabel!
    @IBOutlet weak var icon_iv: UIImageView!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    @IBOutlet weak var labelTrealing: NSLayoutConstraint!

    
    
    var toastHeight: CGFloat {
        let txtString = mtLabel.text! as NSString
        let txtAttributes: [NSAttributedString.Key : Any] = [.font: mtLabel.font]
        let estimatedTextHeight = txtString.boundingRect(with: CGSize(width: 300, height: 2000), options: .usesLineFragmentOrigin, attributes: txtAttributes, context: nil).height
        
        let height = estimatedTextHeight + 30
        
        return height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commentInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commentInit()

    }
    
    func commentInit(){
        Bundle.main.loadNibNamed("ToastView", owner: self, options: nil)
        addSubview(contantView)
        contantView.frame = self.bounds
    }
    
}
