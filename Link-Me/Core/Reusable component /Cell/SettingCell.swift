//
//  SettingCell.swift
//  Link-Me
//
//  Created by Al-attar on 15/06/2023.
//

import UIKit

//struct SettingModel{
//    var icon: UIImage?
//    var name: String?
//    var isArrow: Bool?
//    var isNotificationNumber: Bool?
//    var notificationNumber: Int?
//    var isSwitch: Bool?
//    var isTitle: Bool?
//    var title: String?
//}

class SettingCell: UITableViewCell {

    @IBOutlet weak var arrowIcon_img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var numberOfNotifiaction_lbl: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var icon_img: UIImageView!
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var SpretorLineView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    var toggle: ((Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(data: SettingOptions){
        arrowIcon_img.isHidden = !(data.isArrow ?? false)
        title_lbl.isHidden = !(data.isLabel ?? false)
        numberOfNotifiaction_lbl.isHidden = !(data.isNotificationLabel ?? false)
        onOffSwitch.isHidden = !(data.isToggle ?? false)
        
        
        icon_img.image = UIImage(named: data.icon ?? "")
        name_lbl.text = "lang".localized == "en" ? data.name ?? "" : data.name_ar ?? ""
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        print("BLA 123")
        toggle?(sender.isOn)
    }
}
