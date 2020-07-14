//
//  TimeCalculation.swift
//  Twitterlander
//
//  Created by Fumiaki Kobayashi on 2020/07/17.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

open class TimeCalculation {
    open func dateToString(createdAt: Date) -> String {
        let differenceOfTime = -createdAt.timeIntervalSinceNow
        if differenceOfTime < 60 {
            return "・\(Int(differenceOfTime))秒"
        } else if differenceOfTime < 60*60 {
            return "・\(Int(differenceOfTime/60))分"
        } else if differenceOfTime < 60*60*24 {
            return "・\(Int(differenceOfTime/60/60))時間"
        } else if differenceOfTime < 60*60*24*7 {
            return "・\(Int(differenceOfTime/60/60/24))日"
        } else {
            return "・\(createdAt.twitterStyleDate())"
        }
    }
}
