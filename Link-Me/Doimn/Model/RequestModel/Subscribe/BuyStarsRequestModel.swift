//
//  BuyStarsRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 28/10/2023.
//

import Foundation

struct BuyStarsRequestModel: Encodable {
    let star_price_id: Int
  
    
    enum CodingKeys: String, CodingKey {
        case star_price_id
    }
}
