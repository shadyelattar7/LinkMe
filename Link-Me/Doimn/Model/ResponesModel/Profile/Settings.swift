//
//  Setting.swift
//  Link-Me
//
//  Created by Al-attar on 20/06/2023.
//

import Foundation

struct BaseSettingData: Codable {
    let status : Int?
    let data : [SettingData]

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }
}

struct SettingData: Codable {
    let title : String?
    let title_ar : String?
    let type : Int?
    let options : [SettingOptions]

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case title_ar = "title_ar"
        case type = "type"
        case options = "options"
    }
}

struct SettingOptions: Codable {
    let name : String?
    let name_ar : String?
    let icon : String?
    let isToggle : Bool?
    let isLabel : Bool?
    let isArrow : Bool?
    let isNotificationLabel : Bool?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case name_ar = "name_ar"
        case icon = "icon"
        case isToggle = "isToggle"
        case isLabel = "isLabel"
        case isArrow = "isArrow"
        case isNotificationLabel = "isNotificationLabel"
    }
}
