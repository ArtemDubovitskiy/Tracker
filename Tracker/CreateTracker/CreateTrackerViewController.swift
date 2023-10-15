//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 10.10.2023.
//
import UIKit

final class CreateTrackerViewController: UIViewController {

    var irregularEvent: Bool = false
    private var cellButtonText: [String] = ["Категория", "Расписание"]
    
    // MARK: - Private Properties
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
//        tableView.layer.masksToBounds = true
//        tableView.estimatedRowHeight = 75
//        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // test view / заменить на коллекции
    private lazy var supplyViewTest: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        setupTableView()
        setupCreateTrackerView()
        setupCreateTrackerViewConstrains()
        
        trackerTypeIrregularEvent()
    }
    
    // MARK: - Setup View
    private func setupTableView() {
        createTrackerTableView.delegate = self
        createTrackerTableView.dataSource = self
        
        createTrackerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        createTrackerTableView.register(CreateTrackerCell.self, forCellReuseIdentifier: CreateTrackerCell.cellIdentifier) // заменить на 
    }
    
    private func setupCreateTrackerView() {
        view.backgroundColor = .ypWhiteDay
        
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        scrollView.addSubview(createTrackerName)
        scrollView.addSubview(limitTrackerNameLabel)
        limitTrackerNameLabel.isHidden = true
        scrollView.addSubview(createTrackerTableView)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(supplyViewTest)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
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
            createTrackerTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            createTrackerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createTrackerTableView.heightAnchor.constraint(equalToConstant: irregularEvent ? 75 : 150),
        
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.topAnchor.constraint(equalTo: supplyViewTest.bottomAnchor, constant: 20),
            
            supplyViewTest.heightAnchor.constraint(equalToConstant: 350),
            supplyViewTest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            supplyViewTest.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            supplyViewTest.topAnchor.constraint(equalTo: createTrackerTableView.bottomAnchor, constant: 20)
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
    }
    
    @objc
    private func createButtonTapped() {
        // TODO: - Добавить переход на экран Трекеров (TabBarController)
    }
}

// MARK: - UITableViewDelegate
extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: - UITableViewDataSource
extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if irregularEvent == false {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.text = cellButtonText[indexPath.row]
//        сell.detailTextLabel?.text = //
        cell.textLabel?.textColor = .ypBlackDay
        cell.layer.masksToBounds = true
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        
        return cell
    }
}
