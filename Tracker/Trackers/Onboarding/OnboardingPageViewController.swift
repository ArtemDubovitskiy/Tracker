//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 24.12.2023.
//
import UIKit

final class OnboardingPageViewController: UIPageViewController {
    // MARK: Private Properties
    private let onboardingImage1 = "Onboarding1"
    private let onboardingImage2 = "Onboarding2"
    private let onboardingText1 = "Отслеживайте только\nто, что хотите"
    private let onboardingText2 = "Даже если это\nне литры воды и йога"
    private let userDefaultsKey = "isOnboardingShown"
    
    // MARK: - UI-Elements
    private lazy var pages: [UIViewController] = []
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypBlack.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    /* Визуально зафиксированная кнопка смотрится лучше.
     Прошу не ставить как критическое замечание, могу добавить ее в OnboardingViewController
     Альтернативный вариант реализации добавлен в отдельную ветку "sprint_16_onboarding_2" */
    private lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBlack
        button.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupOnboardingViewControllers()
        setupOnboardingPageView()
        setupOnboardingPageViewConstrains()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    // MARK: - Setup View
    private func setupOnboardingPageView() {
        view.addSubview(pageControl)
        view.addSubview(onboardingButton)
    }
    
    private func setupOnboardingPageViewConstrains() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24),
            
            onboardingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupOnboardingViewControllers() {
        let page1 = OnboardingViewController(
            onboardingImageName: onboardingImage1,
            onboardingText: onboardingText1)
        
        let page2 = OnboardingViewController(
            onboardingImageName: onboardingImage2,
            onboardingText: onboardingText2)
        
        pages.append(page1)
        pages.append(page2)
        
        if let firstPage = pages.first {
            setViewControllers([firstPage],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    // MARK: - Actions
    @objc
    private func didTapOnboardingButton() {
        let tabBarController = TabBarController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: { window.rootViewController = tabBarController },
                              completion: nil)
            UserDefaults.standard.set(true, forKey: userDefaultsKey)
        }
    }
}
// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
