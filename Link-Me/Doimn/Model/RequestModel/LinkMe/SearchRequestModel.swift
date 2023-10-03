//
//  SearchModelRequest.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import Foundation

struct SearchRequestModel: Encodable {
    let gander: String?
    let timePeriod: Int?
    let countryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case gander = "gander"
        case timePeriod = "time_period"
        case countryID = "Country_id"
    }
}
