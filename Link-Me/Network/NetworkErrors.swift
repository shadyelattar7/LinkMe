//
//  NetworkErrors.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation

enum ErrorMessage: String{
    case genericError = "Error reading fetched data"
}


struct ErrorModel: Error, Codable{
    let message: Message?
    let code: String?
    let detail: String?
}

enum Message: Codable {
    case string(String)
    case stringArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Message.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Message"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
    var val: String?{
        switch self {
        case .string(let string):
            return string
        case .stringArray(let array):
            return array.first
        }
    }
}
