//
//  buyStarsRequestModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 28/10/2023.
//

import Foundation


struct buyStarsRequestModel: Encodable {
    let starPriceId: Int?
    
    enum CodingKeys: String, CodingKey {
        case starPriceId = "star_price_id"
    }
}
