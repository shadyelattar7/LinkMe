//
//  String+Date.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/12/2023.
//

import Foundation


/// Use to convert date from formate5 to formate4.
/// EX: -> "2023-12-29T19:10:48.000000Z" -> "7:10 pm"
///
extension String {
    var convertFullDateToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let dateFromStr = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dateFromStr)
    }
}
