//
//  Tracker.swift
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
