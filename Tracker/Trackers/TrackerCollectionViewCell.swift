//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 05.10.2023.
//
import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "trackerCell"
    // MARK: - UI-Elements
    // Card/Tracker
    private let trackerCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pinTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Pin")!,
            target: self,
            action: #selector(pinTrackerButtonTapped))
        button.tintColor = .ypWhiteDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trackerDescritionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhiteDay
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Quantity management
    private let numberOfDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Plus button")!,
            target: self,
            action: #selector(plusTrackerButtonTapped))
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTrackerCollectionView()
        setupTrackerCollectionViewConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Actions
    @objc
    private func pinTrackerButtonTapped() {
        // TODO: - Добавление карточки в Закрепленные
    }
    
    @objc
    private func plusTrackerButtonTapped() {
        // TODO: - Добавить отметку выполнен
    }
    // MARK: - Public Methods
    func updateTrackerDetail(tracker: Tracker) {
        trackerCard.backgroundColor = tracker.color
        trackerDescritionLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        plusTrackerButton.tintColor = trackerCard.backgroundColor
        numberOfDaysLabel.text = "5 дней" // исправить на счетчик дней
        // TODO: - Настроить закрепленные карточки:
        pinTrackerButton.isHidden = true // test
    }
    // MARK: - Setup View
    private func setupTrackerCollectionView() {
        contentView.backgroundColor = .ypWhiteDay
        
        contentView.addSubview(trackerCard)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(pinTrackerButton)
        contentView.addSubview(trackerDescritionLabel)
        contentView.addSubview(numberOfDaysLabel)
        contentView.addSubview(plusTrackerButton)
    }
    
    private func setupTrackerCollectionViewConstrains() {
        NSLayoutConstraint.activate([
            trackerCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCard.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: trackerCard.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: trackerCard.leadingAnchor, constant: 12),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            
            pinTrackerButton.trailingAnchor.constraint(equalTo: trackerCard.trailingAnchor, constant: -4),
            pinTrackerButton.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            pinTrackerButton.heightAnchor.constraint(equalToConstant: 24),
            pinTrackerButton.widthAnchor.constraint(equalToConstant: 24),
            
            trackerDescritionLabel.leadingAnchor.constraint(equalTo: trackerCard.leadingAnchor, constant: 12),
            trackerDescritionLabel.bottomAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: -12),
            trackerDescritionLabel.trailingAnchor.constraint(equalTo: trackerCard.trailingAnchor, constant: -12),
            
            numberOfDaysLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            numberOfDaysLabel.centerYAnchor.constraint(equalTo: plusTrackerButton.centerYAnchor),
            
            plusTrackerButton.topAnchor.constraint(equalTo: trackerCard.bottomAnchor, constant: 8),
            plusTrackerButton.trailingAnchor.constraint(equalTo: trackerCard.trailingAnchor, constant: -12),
            plusTrackerButton.heightAnchor.constraint(equalToConstant: 34),
            plusTrackerButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}
