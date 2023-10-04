//
//  TrackerStructures.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 26.09.2023.
//

import UIKit

struct Tracker {
    let id = UUID()
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
}

struct TrackerCategory {
    let title: String
    let trakers: [Tracker]
}

struct TrackerRecord {
    let trakerId: UUID
    let date: Date
}

enum WeekDay: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var weekName: String {
        switch self {
        case .sunday:
            "Воскресенье"
        case .monday:
            "Понедельник"
        case .tuesday:
            "Вторник"
        case .wednesday:
            "Среда"
        case .thursday:
            "Четверг"
        case .friday:
            "Пятница"
        case .saturday:
            "Суббота"
        }
    }
}
