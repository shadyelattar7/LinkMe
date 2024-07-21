//
//  SecondHeaderChatView.swift
//  Link-Me
//
//  Created by Al-attar on 21/06/2024.
//

import UIKit

class SecondHeaderChatView: UIView {
    
    // MARK: Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    var onBackClick: (() -> Void) = {}
    var onMenuClick: (() -> Void) = {}
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        loadViewFromNib()
    }
    
    // MARK: Actions
    
    @IBAction func backTapped(_ sender: Any) {
        onBackClick()
    }
    
    @IBAction func menuTapped(_ sender: Any) {
        onMenuClick()
    }
}

// MARK: Usage functions
extension SecondHeaderChatView {
    func onClickBackButton(_ onClick: @escaping () -> Void) {
        self.onBackClick = onClick
    }
    
    func onClickMenuButton(_ onClick: @escaping () -> Void) {
        self.onMenuClick = onClick
    }
}
