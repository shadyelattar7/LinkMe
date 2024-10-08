//
//  OtherSeeCell.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import UIKit


class OtherSeeCell: UITableViewCell {

    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var optionsToggle: UISwitch!
    
    var toggleOptions: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionsToggle.addTarget(self, action: #selector(toggleTapped(_:)), for: .valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
 @objc func toggleTapped(_ sender: UISwitch) {
        print("toggleTapped 123")
        toggleOptions?(sender.isOn)
    }
}
