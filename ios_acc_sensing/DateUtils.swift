//
//  DateUtils.swift
//  ios_acc_sensing
//
//  Created by k22120kk on 2023/07/13.
//

import Foundation

class DateUtils {
    static func getNowDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.string(from: now)
    }

    static func stringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.date(from: dateString)
    }

    static func getTimeStamp() -> Int64 {
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        return timeStamp
    }
}

