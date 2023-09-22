//
//  UIImageView+SDWebImage.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import Foundation
import SDWebImage

protocol imageDownloaded {
    func setImage(url: URL?, placeholder: UIImage?)
}

// MARK: - set image with SDWebImage

extension UIImageView: imageDownloaded {
    func setImage(url: URL?, placeholder: UIImage? = nil) {
        self.sd_setImage(with: url, placeholderImage: placeholder)
    }
}
