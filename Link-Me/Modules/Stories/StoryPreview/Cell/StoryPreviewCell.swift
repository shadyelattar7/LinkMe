//
//  StoryPreviewCell.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit

class StoryPreviewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView_iv: UIImageView!
    
    var goNext: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        goNext?()
    }

}
