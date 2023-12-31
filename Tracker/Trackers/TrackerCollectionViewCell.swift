//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 05.10.2023.
//
import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    static let identifier = "trackerCell"
    weak var delegate: TrackerCollectionViewCellDelegate?
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
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
        label.font = .systemFont(ofSize: 14, weight: .medium)
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
    
    private let plusButtonImage: UIImage = {
        let image = UIImage(systemName: "plus")!
        return image
    }()
    
    private let doneButtonImage: UIImage = {
        let image = UIImage(named: "Done")!
        return image
    }()
    
    private lazy var plusTrackerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17
        button.tintColor = .ypWhiteDay
        button.addTarget(self,
                         action: #selector(plusTrackerButtonTapped),
                         for: .touchUpInside)
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
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no trackerId")
            return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
    // MARK: - Public Methods
    func updateTrackerDetail(
        tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        trackerCard.backgroundColor = tracker.color
        trackerDescritionLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        // TODO: - Настроить закрепленные карточки:
        pinTrackerButton.isHidden = true // test
        numberOfDaysLabel.text = formattedDays(completedDays)
        plusButtonSettings()
    }
    // MARK: - Private Methods
    private func plusButtonSettings() {
        plusTrackerButton.backgroundColor = trackerCard.backgroundColor
        
        let plusTrackerButtonOpacity: Float = isCompletedToday ? 0.3 : 1
        plusTrackerButton.layer.opacity = plusTrackerButtonOpacity

        let image = isCompletedToday ? doneButtonImage : plusButtonImage
        plusTrackerButton.setImage(image, for: .normal)
    }
    
    private func formattedDays(_ completedDays: Int) -> String {
        let number = completedDays % 10
        if number == 1 && number != 0 {
            return "\(completedDays) день"
        } else if number <= 4 && number > 1 {
            return "\(completedDays) дня"
        } else {
            return "\(completedDays) дней"
        }
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
