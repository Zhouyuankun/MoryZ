//
//  Model.swift
//  MoryZ
//
//  Created by 周源坤 on 2021/12/8.
//

import Foundation

enum Mood: String, CaseIterable, Identifiable, CustomStringConvertible {
    
    case happy = "😄"
    case embarrass = "😅"
    case moving = "🥰"
    case angry = "😡"
    case sick = "🤢"
    
    var id: Int {
        self.hashValue
    }
    
    var description: String {
        return self.rawValue
    }
    
}

enum Weather: String, CaseIterable, Identifiable, CustomStringConvertible {
    case clear = "☀️"
    case semicloudy = "🌤"
    case cloudy = "☁️"
    case rainy = "🌧"
    case snowy = "❄️"
    case foggy = "🌫"
    
    var id: Int {
        self.hashValue
    }
    
    var description: String {
        return self.rawValue
    }
    
}

enum Mean: String, CaseIterable, Identifiable, CustomStringConvertible {
    case meaningless = "✨"
    case meaningcommon = "⭐️"
    case meaningful = "🌟"
    
    var id: Int {
        self.hashValue
    }
    
    var description: String {
        return self.rawValue
    }
}

enum DisplayMode: Int, CaseIterable, Identifiable {
    case all, yearly, monthly, weekly
    
    var name: String {
        switch self {
        case .all: return String(localized: "All")
        case .yearly: return String(localized: "Year")
        case .monthly: return String(localized: "Month")
        case .weekly: return String(localized: "Week")
        }
    }
    
    var id: Int {
        self.rawValue
    }
    
    var predicate: NSPredicate {
        switch self {
        case .all: return NSPredicate(format: "date >= %@", Date(timeIntervalSince1970: 0) as NSDate)
        case .yearly: return NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Date().startOfYear, Date().endOfYear])
        case .monthly: return NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Date().startOfMonth, Date().endOfMonth])
        case .weekly: return NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Date().startOfWeek, Date().endOfWeek])
        }
    }
}



