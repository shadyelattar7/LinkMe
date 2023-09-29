//
//  BeInTopResources.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/09/2023.
//

import Foundation

// MARK: Model that used to fill be in top card.

struct BeInTopModel {
    let numberOfUsers: Int?
    let stars: [StarModel]?
}

struct StarModel {
    let id, diamonds: Int?
    let titleAr, titleEn: String?
}
