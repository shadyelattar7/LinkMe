//
//  NavigationBarView.swift
//  Link-Me
//
//  Created by Al-attar on 14/05/2023.
//

import UIKit

struct NavigationBarViewModel {
    // Mark: - Properties
    var navBarTitle: String = ""
}

protocol NavigationBarDelegate: AnyObject{
    func backButtonPressed()
}

class NavigationBarView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var title_lbl: UILabel!
    
    // MARK: - Properties
    
    private let nibName = "NavigationBarView"
    weak var navBarDelegate: NavigationBarDelegate?
    
    private var viewModel: NavigationBarViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            setData(with: viewModel)
        }
    }
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    
    // MARK: - Private Methods
    
    private func xibSetUp() {
        viewContainer = loadViewFromNib()
        viewContainer.frame = self.bounds
        viewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(viewContainer)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func setData(with viewModel: NavigationBarViewModel) {
        
        title_lbl.text = viewModel.navBarTitle
    }
    
    @IBInspectable var isTitleLarge: Bool = false {
        didSet {
            if isTitleLarge {
                if "lang".localized == "en"{
                    title_lbl.font = UIFont(name: ENFont.Bold.rawValue, size: 22.0)
                }else{
                    title_lbl.font = UIFont(name: ARFont.Bold.rawValue, size: 22.0)
                }
            }else{
                
                if "lang".localized == "en"{
                    title_lbl.font = UIFont(name: ENFont.Regular.rawValue, size: 18)
                }else{
                    title_lbl.font = UIFont(name: ARFont.Regular.rawValue, size: 18)
                }
            }
        }
    }
    
    // MARK: - configure Methods
    
    func configure(with viewModel: NavigationBarViewModel,
                   and delegate: NavigationBarDelegate) {
        self.viewModel = viewModel
        self.navBarDelegate = delegate
    }
    
    // MARK: - Actions
    
    @IBAction func backTapped(_ sender: Any) {
        guard let navBarDelegate = navBarDelegate else {
            return
        }
        navBarDelegate.backButtonPressed()
    }
    
    
}

