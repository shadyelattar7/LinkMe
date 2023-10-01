//
//  SupscriptionSubscribeRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 01/10/2023.
//

import Foundation

struct SupscriptionSubscribeRequestModel: Encodable {
    let supscription_plan_id: Int
    let transction_id: Int
    let paid_by: String
    
    enum CodingKeys: String, CodingKey {
        case supscription_plan_id
        case transction_id
        case paid_by
    }
}
