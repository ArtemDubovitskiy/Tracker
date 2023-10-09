//
//  StaticticsViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 04.10.2023.
//

import UIKit

final class StaticticsViewController: UIViewController {
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let staticticsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stub statistics")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let staticticsLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStaticticsView()
        setupStaticticsViewConstrains()
    }
    // MARK: - Private Methods
    private func setupStaticticsView() {
        view.backgroundColor = .ypWhiteDay
        view.addSubview(titleLabel)
        view.addSubview(staticticsImage)
        view.addSubview(staticticsLabel)
    }
    
    func setupStaticticsViewConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            staticticsImage.heightAnchor.constraint(equalToConstant: 80),
            staticticsImage.widthAnchor.constraint(equalToConstant: 80),
            staticticsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticticsImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            staticticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            staticticsLabel.topAnchor.constraint(equalTo: staticticsImage.bottomAnchor, constant: 8)
        ])
    }
}
