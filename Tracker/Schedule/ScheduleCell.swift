//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 16.10.2023.
//
import UIKit

final class ScheduleCell: UITableViewCell {
    static let cellIdentifier = "scheduleCell"
    
    var selectedSwitcher = false
    
    private let switcher: UISwitch = {
        let swith = UISwitch()
        swith.onTintColor = .ypBlue
        swith.addTarget(self, action: #selector(switcherTapped), for: .touchUpInside)
        swith.translatesAutoresizingMaskIntoConstraints = false
        return swith
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .ypBackgroundDay
        clipsToBounds = true
        
        addSubview(switcher)
        self.accessoryView = switcher
        
        NSLayoutConstraint.activate([
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor),
            switcher.centerYAnchor.constraint(equalTo: centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func switcherTapped(_ sender: UISwitch) {
        self.selectedSwitcher = sender.isOn
    }
}
