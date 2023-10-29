//
//  BuyDiamondsRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 28/10/2023.
//

import Foundation

struct BuyDiamondsRequestModel: Encodable {
    let product_id: Int
    let transaction_id: Int
    let paid_by: String
    
    enum CodingKeys: String, CodingKey {
        case product_id
        case transaction_id
        case paid_by
    }
}
