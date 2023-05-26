//
//  Alertable.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation
import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {
    
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: "Got it!", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: completion)
    }
}
