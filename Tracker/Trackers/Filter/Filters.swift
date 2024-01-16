//
//  Filters.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 16.01.2024.
//
import Foundation

enum Filters: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case trackersToday = "Трекеры на сегодня"
    case completedTrackers =  "Завершенные"
    case unCompletedTrackers =  "Не завершенные"
}
