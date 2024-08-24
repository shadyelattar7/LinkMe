//
//  String+Extension.swift
//  POMacArch
//
//  Created by Mohamed gamal on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

enum DateFormate: String {
    case yearMonthDay = "yyyy-MM-dd HH:mm:ss"
    case yearMonthMinutes = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case dayMonthYear = "dd MMMM yyyy"
    case dayMonthYearWihoutHour = "dd-MM-yyyy"
    case dayMonth = "dd MMM"
    case hourMinute = "hh:mm a"
    case hourMinuteAgo = "HH:mm"
    case nameDayMonthYear = "E, dd MMMM yyyy"
    case yearMonthDayWithoutHour = "yyyy-MM-dd"
    case day = "E"
    case year = "yyyy"
    case month = "MMMM"
    case yearMonthMinutesWithZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case dayMonthMinutesWithZ = "E MMM dd HH:mm:ss zzz yyyy"
    case dayMonYear =  "dd MMM yyyy"
//    case YearMonday = "yyyy MMM dd"
}

extension String {
    /// A localized value form Localizable base on current app loacl
//    var localized: String {
//        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
    /// A Boolean value indicating whether a string has no characters after removing all whitespaces and all newlines.
    var hasValue: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count != 0
    }

    func toDate(format: DateFormate) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale.init(identifier: "en_US")
        let date = dateFormatter.date(from: self)
        return date
    }

    func removeWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}
extension String {
    func indexOf(char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }

    func validate(for type: ValidatorType) throws {
        let validator = ValidatorResolver.validate( for: type)
        return try validator.validate(self)
    }
    func isValid(type: ValidatorType) -> Bool {
        let validator = ValidatorResolver.validate(for: type)
        return validator.isValid(self)
    }

}

// MARK: Calculate age form birthdate

extension String {
    func calculateAge() -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let birthdayDate = dateFormater.date(from: self)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age ?? 0
    }
}
