//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 05.09.2023.
//
import UIKit

final class TrackersViewController: UIViewController {
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Add tracker")!,
            target: TrackersViewController?.self,
            action: #selector(didTapAddTrackerButton))
        button.tintColor = .ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.calendar.firstWeekday = 2
        date.addTarget(self, action: #selector(dateSelection), for: .valueChanged)
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let search = UISearchTextField()
        
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private let trackersImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stub tracker")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stub tracker")
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackersView()
        setupTrackersViewConstrains()
    }
    // MARK: - Private Methods
    func setupTrackersView() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(addTrackerButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchField)
        view.addSubview(trackersImage)
        view.addSubview(trackersLabel)
//        view.addSubview(searchImage) // добавить функцию показывающую изображение и текст при пустом поиске
//        view.addSubview(searchLabel)

    }
    
    func setupTrackersViewConstrains() {
        NSLayoutConstraint.activate([
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            trackersImage.heightAnchor.constraint(equalToConstant: 80),
            trackersImage.widthAnchor.constraint(equalToConstant: 80),
            trackersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersLabel.topAnchor.constraint(equalTo: trackersImage.bottomAnchor, constant: 8)
        ])
    }
    
    @objc
    private func didTapAddTrackerButton() {
        
    }
    
    @objc
    private func dateSelection() {
        
    }
}

