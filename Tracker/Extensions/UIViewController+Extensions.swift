//
//  UIViewController+Extensions.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 21.11.2023.
//
import UIKit

extension UIViewController {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
