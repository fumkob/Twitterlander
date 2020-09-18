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
        
        static let twitterDateStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY/MM/dd"
            return formatter
        }()
        
        static let twitterTimeStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        
        static let profileDateStyle: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY年MM月"
            return formatter
        }()
    }
    init?(fromISO8601 string: String) {
        guard let date = Const.ISO8601Formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    func twitterDateStyle() -> String {
        return Const.twitterDateStyle.string(from: self)
    }
    func twitterTimeStyle() -> String {
        return Const.twitterTimeStyle.string(from: self)
    }
    func profileDateStyle() -> String {
        return Const.profileDateStyle.string(from: self)
    }
}
