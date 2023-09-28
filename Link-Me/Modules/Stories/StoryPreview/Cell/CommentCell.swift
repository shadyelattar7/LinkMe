//
//  CommentCell.swift
//  Link-Me
//
//  Created by Al-attar on 24/09/2023.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    var deleteTap: (() ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deleteTap?()
    }
}
