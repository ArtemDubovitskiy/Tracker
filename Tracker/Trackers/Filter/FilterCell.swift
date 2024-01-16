//
//  FilterCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 11.01.2024.
//
import UIKit

final class FilterCell: UITableViewCell {
    static let cellIdentifier = "FilterCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .ypBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
