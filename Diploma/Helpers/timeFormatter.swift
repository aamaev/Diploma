//
//  timeFormatter.swift
//  Diploma
//
//  Created by Артём Амаев on 27.02.24.
//

import Foundation
import Firebase

func timeFormatter(from timestamp: Timestamp) -> String {
    let secondsAgo = Int(Date().timeIntervalSince(timestamp.dateValue()))
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    
    if secondsAgo < minute {
        return "\(secondsAgo) second\(secondsAgo == 1 ? "" : "s") ago"
    } else if secondsAgo < hour {
        let minutes = secondsAgo / minute
        return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
    } else if secondsAgo < day {
        let hours = secondsAgo / hour
        return "\(hours) hour\(hours == 1 ? "" : "s") ago"
    } else if secondsAgo < week {
        let days = secondsAgo / day
        return "\(days) day\(days == 1 ? "" : "s") ago"
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: timestamp.dateValue())
    }
}
