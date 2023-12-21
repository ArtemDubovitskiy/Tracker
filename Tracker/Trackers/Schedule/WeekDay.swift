//
//  WeekDay.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 17.10.2023.
//
import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var daysName: String {
        switch self {
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
        case .sunday:
            "Воскресенье"
        }
    }
    
    var shortDaysName: String {
        switch self {
        case .monday:
            "Пн"
        case .tuesday:
            "Вт"
        case .wednesday:
            "Ср"
        case .thursday:
            "Чт"
        case .friday:
            "Пт"
        case .saturday:
            "Сб"
        case .sunday:
            "Вс"
        }
    }
}
