//
//  Date+Extension.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 19.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import Foundation

extension Date {

    var minute: Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let minutes = calendar.component(.minute, from: self)
        let hours = calendar.component(.hour, from: self)
        let totalMinutes = hours*60 + minutes
        return totalMinutes
    }

    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: self)
        return month
    }

    var year: Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let year = calendar.component(.year, from: self)
        return year
    }

    var midnight:Date{
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }

}
