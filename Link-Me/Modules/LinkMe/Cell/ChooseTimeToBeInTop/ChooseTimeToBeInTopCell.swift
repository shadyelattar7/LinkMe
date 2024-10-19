//
//  ChooseTimeToBeInTopCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 25/09/2023.
//

import UIKit

class ChooseTimeToBeInTopCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var numberOfDiamondLabel: UILabel!
    @IBOutlet private weak var activeButton: UIButton!
    
    // MARK: - Proprites
    private var type: TypeOfActiveButton = .choose
    var onChange: ((TypeOfActiveButton)->()) = { _ in }
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func didTappedOnActiveButton(_ sender: Any) {
        onChange(type)
    }

    func update(_ item: StarModel) {
        timeLabel.text = "lang".localized == "en" ? item.titleEn : item.titleAr
        numberOfDiamondLabel.text = "\(item.diamonds ?? 0) " + "Diamond".localized
        checkIfAvailableChooseIt(item.isAvailableToChoose ?? false)
    }
}

// MARK: Private Handlers

extension ChooseTimeToBeInTopCell {
    private func checkIfAvailableChooseIt(_ isAvailable: Bool) {
        switch isAvailable {
        case true:
            activeButton.setTitle("Choose".localized, for: .normal)
            type = .choose
            activeButton.applyDefaultStyle(cornerRadius: 10, backgroundColor: .yellow, textColor: .white)
            parentView.backgroundColor = .lightYellow
            parentView.applyBorderStyle(borderColor: .yellow, borderWidth: 1, cornerRadius: 10, textColor: .white)
        case false:
            activeButton.setTitle("Buy".localized, for: .normal)
            type = .buy
            activeButton.applyBorderStyle(borderColor: .yellow, borderWidth: 1, cornerRadius: 10, textColor: .yellow)
            parentView.backgroundColor = .lightGray
            parentView.cornerRadius = 10
        }
    }
}

// MARK: - Resources

extension ChooseTimeToBeInTopCell {
    enum TypeOfActiveButton {
        case choose
        case buy
    }
}
