//
//  AddNewStoryRequestModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import Foundation

struct AddNewStoryRequestModel: Encodable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case text
    }
}
