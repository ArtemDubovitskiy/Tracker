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
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "Trackers"),
            selectedImage: nil
        )
        
        let staticticsViewController = StaticticsViewController()
        staticticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Stats"),
            selectedImage: nil
        )
        self.viewControllers = [trackersViewController, staticticsViewController]
    }
}

