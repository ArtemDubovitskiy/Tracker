//
//  TabBarController.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 26.09.2023.
//
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("app.title", comment: ""),
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let staticticsViewController = StaticticsViewController()
        staticticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistic.title", comment: ""),
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        self.viewControllers = [trackersViewController, staticticsViewController]
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.ypWhite
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}
