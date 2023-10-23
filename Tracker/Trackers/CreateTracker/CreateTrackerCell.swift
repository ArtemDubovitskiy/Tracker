//
//  CreateTrackerCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 11.10.2023.
//
import UIKit

final class CreateTrackerCell: UITableViewCell {
    static let cellIdentifier = "CreateTrackerCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
