//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 04.10.2023.
//
import UIKit

final class AddTrackerViewController: UIViewController {
    weak var trackersViewController: TrackersViewController?
    // MARK: - UI-Elements
    private lazy var titleAddTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTrackersView()
        setupAddTrackersViewConstrains()
    }
    // MARK: - Actions
    @objc
    private func didTapHabitButton() {
        let createTracker = CreateTrackerViewController(editTracker: false)
        createTracker.irregularEvent = false
        createTracker.delegate = self.trackersViewController
        present(createTracker, animated: true, completion: nil)
    }
    
    @objc
    private func didTapIrregularEventButton() {
        let createTracker = CreateTrackerViewController(editTracker: false)
        createTracker.irregularEvent = true
        createTracker.delegate = self.trackersViewController
        present(createTracker, animated: true, completion: nil)
    }
    // MARK: - Setup View
    private func setupAddTrackersView() {
        view.backgroundColor = .ypWhite
        habitButton.backgroundColor = .ypBlack
        view.addSubview(titleAddTrackersLabel)
        view.addSubview(habitButton)
        view.addSubview(irregularEventButton)
    }
    
    private func setupAddTrackersViewConstrains() {
        NSLayoutConstraint.activate([
            titleAddTrackersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleAddTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
