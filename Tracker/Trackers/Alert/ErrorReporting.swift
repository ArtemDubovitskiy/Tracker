//
//  ErrorReporting.swift
//  Tracker
//
//  Created by Artem Dubovitsky on 21.12.2023.
//
import UIKit

final class ErrorReporting {
    static func showAlert(message: String, controller: UIViewController) {
        let alert = UIAlertController(
            title: "Error!",
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        controller.present(alert, animated: true, completion: nil)
    }
}
