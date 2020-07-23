//
//  DateExtension.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/14.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

extension Date {
    private struct Const {
        static let ISO8601Formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            return dateFormatter
        }()
        
        static let twitterStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            return formatter
        }()
    }
    init?(fromISO8601 string: String) {
        guard let date = Const.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    func twitterStyleDate() -> String {
        return Const.twitterStyle.string(from: self)
    }
}
