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
    private let buttonText = "Вот это технологии!"
    // MARK: - UI-Elements
    private lazy var pages: [UIViewController] = []
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypBlackDay.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
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
    }
    
    private func setupOnboardingPageViewConstrains() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
    
    private func setupOnboardingViewControllers() {
        let page1 = OnboardingViewController(
            onboardingImageName: onboardingImage1,
            onboardingText: onboardingText1, 
            onboardingButtonText: buttonText)
        
        let page2 = OnboardingViewController(
            onboardingImageName: onboardingImage2,
            onboardingText: onboardingText2, 
            onboardingButtonText: buttonText)
        
        pages.append(page1)
        pages.append(page2)
        
        if let firstPage = pages.first {
            setViewControllers([firstPage],
                               direction: .forward,
                               animated: true,
                               completion: nil)
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
