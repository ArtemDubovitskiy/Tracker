//
//  CategoryCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 29.12.2023.
//
import UIKit

final class CategoryCell: UITableViewCell {
    static let cellIdentifier = "CategoryCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .ypBackgroundDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
