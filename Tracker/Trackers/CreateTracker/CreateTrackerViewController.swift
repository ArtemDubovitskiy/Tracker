//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 10.10.2023.
//
import UIKit

final class CreateTrackerViewController: UIViewController {
    var irregularEvent: Bool = false
    // MARK: - Private Properties
    private var cellButtonText: [String] = ["Категория", "Расписание"]
    private var selectedCategory: String?
    private var selectedDays: [WeekDay] = []
    private var collectionViewHeightContraint: NSLayoutConstraint!
    private let emojies = [
        "🙂","😻","🌺","🐶","❤️","😱",
        "😇","😡","🥶","🤔","🙌","🍔",
        "🥦","🏓","🥇","🎸","🏝","😪"
    ]
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3,
        .colorSelection4, .colorSelection5, .colorSelection6,
        .colorSelection7, .colorSelection8, .colorSelection9,
        .colorSelection10, .colorSelection11, .colorSelection12,
        .colorSelection13, .colorSelection14, .colorSelection15,
        .colorSelection16, .colorSelection17, .colorSelection18
    ]
    // MARK: - UI-Elements
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.backgroundColor = .ypWhiteDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createTrackerName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.textColor = .ypBlackDay
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .ypBackgroundDay
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var limitTrackerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createTrackerTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBackgroundDay
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhiteDay
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var createTrackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
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
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypGray
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        
        setupTableView()
        setupCollectionView()
        setupCreateTrackerView()
        setupCreateTrackerViewConstrains()
        createTrackerCollectionViewHeight()
        trackerTypeIrregularEvent()
    }
    
    // MARK: - Setup View
    private func setupTableView() {
        createTrackerTableView.delegate = self
        createTrackerTableView.dataSource = self
        
        createTrackerTableView.register(UITableViewCell.self, 
                                        forCellReuseIdentifier: "cell")
        createTrackerTableView.register(CreateTrackerCell.self, 
                                        forCellReuseIdentifier: CreateTrackerCell.cellIdentifier)
    }
    
    private func setupCollectionView() {
        self.createTrackerCollectionView.delegate = self
        self.createTrackerCollectionView.dataSource = self
        
        createTrackerCollectionView.register(EmojiCollectionViewCell.self,
                                             forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        createTrackerCollectionView.register(ColorsCollectionViewCell.self,
                                             forCellWithReuseIdentifier: ColorsCollectionViewCell.identifier)
        createTrackerCollectionView.register(HeaderViewCell.self, 
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                             withReuseIdentifier: HeaderViewCell.identifier)
        collectionViewHeightContraint = createTrackerCollectionView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func setupCreateTrackerView() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        scrollView.addSubview(createTrackerName)
        scrollView.addSubview(limitTrackerNameLabel)
        limitTrackerNameLabel.isHidden = true
        scrollView.addSubview(createTrackerTableView)
        scrollView.addSubview(createTrackerCollectionView)
        
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
    }
    
    private func createTrackerCollectionViewHeight() {
        createTrackerCollectionView.collectionViewLayout.invalidateLayout()
        createTrackerCollectionView.layoutIfNeeded()
        collectionViewHeightContraint.constant = createTrackerCollectionView.contentSize.height
    }
    
    private func setupCreateTrackerViewConstrains() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createTrackerName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createTrackerName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTrackerName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            createTrackerName.heightAnchor.constraint(equalToConstant: 75),
            
            limitTrackerNameLabel.centerXAnchor.constraint(equalTo: createTrackerName.centerXAnchor),
            limitTrackerNameLabel.topAnchor.constraint(equalTo: createTrackerName.bottomAnchor, constant: 8),
            
            createTrackerTableView.topAnchor.constraint(equalTo: createTrackerName.bottomAnchor, constant: 24), // добавить изменение высоты при >38 символов
            createTrackerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createTrackerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTrackerTableView.heightAnchor.constraint(equalToConstant: irregularEvent ? 75 : 150),
            
            collectionViewHeightContraint,
            createTrackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            createTrackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTrackerCollectionView.topAnchor.constraint(equalTo: createTrackerTableView.bottomAnchor, constant: 16),

            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.topAnchor.constraint(equalTo: createTrackerCollectionView.bottomAnchor, constant: 16)
        ])
    }
    // MARK: - Private Methods
    private func trackerTypeIrregularEvent() {
        if irregularEvent == true {
            cellButtonText = ["Категория"]
            self.titleLabel.text = "Новое нерегулярное событие"
        }
    }
    // MARK: - Actions
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
        // TODO: Добавить сброс заполненных данных
    }
    
    @objc
    private func createButtonTapped() {
        // TODO: - Добавить переход на экран Трекеров (TabBarController)
    }
}
// MARK: - ScheduleViewControllerDelegate
extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func saveSelectedDays(list: [Int]) {
        for index in list {
            self.selectedDays.append(WeekDay.allCases[index])
            self.createTrackerTableView.reloadData()
        }
    }
}
// MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            present(categoryViewController, animated: true, completion: nil)
        } else
        if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true, completion: nil)
            selectedDays = []
        }
        createTrackerTableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        if irregularEvent == false {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.text = cellButtonText[indexPath.row]
        cell.textLabel?.textColor = .ypBlackDay
        cell.layer.masksToBounds = true
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        guard let detailTextLabel = cell.detailTextLabel else { return cell }
        detailTextLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        detailTextLabel.textColor = .ypGray
        
        if indexPath.row == 0 {
            detailTextLabel.text = "" //add selectedCategory
        } else if indexPath.row == 1 {
            if selectedDays.count == 7 {
                detailTextLabel.text = "Каждый день"
            } else {
                detailTextLabel.text = selectedDays.map { $0.shortDaysName }.joined(separator: ", ")
            }
        }
        return cell
    }
}
// MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView
    ) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell() }
            cell.emojiLabel.text = emojies[indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorsCollectionViewCell.identifier,
                for: indexPath) as? ColorsCollectionViewCell else { return UICollectionViewCell() }
            cell.colorView.backgroundColor = colors[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
}
// MARK: - UICollectionViewDelegate
extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, 
                        didSelectItemAt indexPath: IndexPath
    ) {
        // TODO: add select item
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderViewCell.identifier
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, 
                                                                   withReuseIdentifier: id,
                                                                   for: indexPath) as! HeaderViewCell
        if indexPath.section == 0 {
            view.titleLabel.text = "Emoji"
        } else {
            view.titleLabel.text = "Цвет"
        }
        return view
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, 
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                         withHorizontalFittingPriority: .required,
                                                         verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 5
    }
}
