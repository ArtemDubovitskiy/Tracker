//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 10.10.2023.
//
import UIKit

final class CreateTrackerViewController: UIViewController {

    var irregularEvent = false
    
    // MARK: - Private Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypRed
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhiteDay
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIrregularEventView()
        setupAIrregularEventViewConstrains()
        
    }
    
    // MARK: - Private Methods
    private func setupIrregularEventView() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(titleLabel)
        view.addSubview(createTrackerTableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
    }
    
    private func setupAIrregularEventViewConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width) - 4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width) - 4),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
    }

    
    // MARK: - Actions
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func createButtonTapped() {
        // TODO: - Добавить переход на экран Трекеров (TabBarController)
    }
}
