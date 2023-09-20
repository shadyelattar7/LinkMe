//
//  StoryPreviewCell.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

class StoryPreviewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imageView_iv: UIImageView!
    
    var nextStory: (()->())?
    var previousStory: (()->())?
    var isScrolled: Bool = false
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView_iv.image = nil

    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("next story")
        nextStory?()
    }

    @IBAction func previousStoryTapped(_ sender: Any) {
        print("previousStoryTapped")
        previousStory?()
    }
}
