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
    
    var toggleOptions: ((Bool)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func toggleTapped(_ sender: UISwitch) {
        print("toggleTapped 123")
        toggleOptions?(sender.isOn)
    }
}
