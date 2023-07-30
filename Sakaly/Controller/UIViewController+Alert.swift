//
//  UIViewController+Alert.swift
//  Sakaly
//
//  Created by Ahmed Alaa on 24/06/2023.
//

import UIKit

extension UIViewController {
    func showAler(message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
