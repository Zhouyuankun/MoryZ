//
//  DateConvertor.swift
//  DiaryZ
//
//  Created by celeglow on 2021/8/19.
//

import Foundation

func getDay(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.day, from: date)
}

func getMonth(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.month, from: date)
}

func getYear(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.year, from: date)
}

func getSecond(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.second, from: date)
}

func getMinute(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.minute, from: date)
}

func getHour(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.hour, from: date)
}

func getWeekday(date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.weekday, from: date)
}

func getTimeStamp(formattedStr: String) -> TimeInterval {
    let yourDate = formattedStr

    //initialize the Date Formatter
    let dateFormatter = DateFormatter()

    //specify the date Format
    dateFormatter.dateFormat="yyyy-MM-dd"

    //get date from string
    let dateString = dateFormatter.date(from: yourDate)

    //get timestamp from Date
    return dateString!.timeIntervalSince1970
}

func getRawTime(date: Date) -> String{
    let hour = getHour(date: date)
    let minute = getMinute(date: date)
    return ((hour > 9) ? "\(hour)" : "0\(hour)") + ":" + ((minute > 9) ? "\(minute)" : "0\(minute)")
}

func weekdayFromNumToString(weekday: Int) -> String {
    let weekdayList = [String(localized: "Sun."), String(localized: "Mon."), String(localized: "Tue."), String(localized: "Wed."), String(localized: "Thu."), String(localized: "Fri."), String(localized: "Sat.")]
    guard weekday > 0 && weekday <= 7 else {
        return "UNKONWN"
    }
    return weekdayList[weekday - 1]
}

func monthFromNumToString(month: Int) -> String{
    let monthList = [
        String(localized: "Jan."), String(localized: "Feb."), String(localized: "Mar."), String(localized: "Apr."), String(localized: "May."), String(localized: "Jun."), String(localized: "Jul."), String(localized: "Aug."), String(localized: "Sep."), String(localized: "Oct."), String(localized: "Nov."), String(localized: "Dec.")
    ]
    guard month > 0 && month <= 12 else {
        return "UNKNOWN"
    }
    return monthList[month - 1]
}

extension Date {
    
    var startOfYear: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year], from: self)
        return  calendar.date(from: components)!
    }
    
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfYear)!
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfWeek: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return  calendar.date(from: components)!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.day = 7
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfWeek)!
    }
    
    
}
