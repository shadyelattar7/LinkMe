//
//  UserCardResources.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import Foundation


// MARK: Model that used to fill user card.

struct UserCardModel {
    let id: Int?
    let imagePath: String?
    let name: String?
    let username: String?
    let bio: String?
    let numberOfLinks: Int?
    let numberOfFollowing: Int?
    let numberOfLikes: Int?
    let can_see_links: Int?
    let can_see_followers: Int?
    let can_see_likes: Int?
}
