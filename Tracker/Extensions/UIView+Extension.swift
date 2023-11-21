//
//  UIView+Extension.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 21.11.2023.
//
import UIKit

extension UIView {

    public func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc 
    func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
