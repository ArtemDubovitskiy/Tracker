//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 05.09.2023.
//
import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Private Properties
    private var trackers: [Tracker] = []
    private var categories: [TrackerCategory] = [
        // Mock - для отладки поиска и фильтра по дате:
        TrackerCategory(
            title: "Радостные мелочи",
            trackers: [
                Tracker(id: UUID(),
                        title: "Кошка заслонила камеру на созвоне",
                        color: .colorSelection2,
                        emoji: "😻",
                        schedule: [.monday, .friday]),
                Tracker(id: UUID(),
                        title: "Бабушка прислала открытку в вотсапе",
                        color: .colorSelection1,
                        emoji: "🌺",
                        schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
                Tracker(id: UUID(),
                        title: "Свидание в апреле",
                        color: .colorSelection14,
                        emoji: "❤️",
                        schedule: [.saturday])]
        )]
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var selectedDay: Int?
    private var filterText: String?
    
    // MARK: - UI-Elements
    private lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .compact
        date.calendar.firstWeekday = 2
        date.addTarget(self, action: #selector(dateSelection), for: .valueChanged)
        date.locale = Locale(identifier: "ru_RU")
        date.tintColor = .ypBlue
        date.clipsToBounds = true
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .ypBlue
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        imageView.image = UIImage(named: "Stub search")
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
        visibleCategories = categories
        
        testCategory()
        setupNavBar()
        setupTrackersView()
        setupCollectionView()
        setupTrackersViewConstrains()
        dateFiltering()
    }
    // MARK: - Setup View
    // TODO: Тестовая категория, удалить после создания категорий:
    private func testCategory() {
        let testCategory = TrackerCategory(title: "Test category", trackers: trackers)
        categories.append(testCategory)
    }
    
    private func setupNavBar() {
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .ypBlackDay
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Add tracker"),
            style: .plain,
            target: self,
            action: #selector(didTapAddTrackerButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func setupTrackersView() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(trackersImage)
        view.addSubview(trackersLabel)
        view.addSubview(collectionView)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(HeaderViewCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderViewCell.identifier)
    }
    
    private func setupTrackersViewConstrains() {
        NSLayoutConstraint.activate([
            trackersImage.heightAnchor.constraint(equalToConstant: 80),
            trackersImage.widthAnchor.constraint(equalToConstant: 80),
            trackersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackersLabel.topAnchor.constraint(equalTo: trackersImage.bottomAnchor, constant: 8),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    // MARK: - Actions
    @objc
    private func didTapAddTrackerButton() {
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.trackersViewController = self
        present(addTrackerViewController, animated: true, completion: nil)
    }
    
    @objc
    private func dateSelection() {
        dateFiltering()
        reloadVisibleCategories()
    }
    // MARK: - Private Methods
    private func dateFiltering() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: datePicker.date)
        self.selectedDay = filterWeekday
    }
    
    private func reloadVisibleCategories() {
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = (self.filterText ?? "").isEmpty ||
                    tracker.title.contains(self.filterText ?? "")
                let dateCondition = tracker.schedule.contains { day in
                    guard let cerrentDate = self.selectedDay else {
                        return true
                    }
                    return day.rawValue == cerrentDate
                } == true
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
    
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        collectionView.reloadData()
    }
}
// MARK: - UITextFieldDelegate
extension TrackersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        dateFiltering()
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterText = searchController.searchBar.searchTextField.text?.description
        reloadVisibleCategories()
    }
}
// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackerViewControllerDelegate {
    func createNewTracker(tracker: Tracker) {
        // TODO: Добавить выбранную категорию в следующих спринтах.
        self.categories = self.categories.map { testCategory in
            var updateTrackers = testCategory.trackers
            updateTrackers.append(tracker)
            return TrackerCategory(title: testCategory.title, trackers: updateTrackers)
        }
        reloadVisibleCategories()
        collectionView.reloadData()
    }
}
// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        cell.prepareForReuse()
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.updateTrackerDetail(tracker: tracker)
        // TODO - дополнить конфигурацию ячейки
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
}
// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderViewCell.identifier
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath) as! HeaderViewCell
        
        guard indexPath.section < visibleCategories.count else {
            return view
        }
        
        let headerText = visibleCategories[indexPath.section].title
        view.headerTextLabel = headerText
        return view
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
