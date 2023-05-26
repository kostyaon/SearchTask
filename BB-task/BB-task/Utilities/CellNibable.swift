//
//  CellNibable.swift
//  BB-task
//
//  Created by KonstanTanos on 26/05/2023.
//

import Foundation
import UIKit

protocol CellNibable {
    
    static var reuseIdentifier: String { get }
    static func getNib() -> UINib
}

extension CellNibable where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
    
    static func getNib() -> UINib {
        return UINib(nibName: Self.reuseIdentifier, bundle: nil)
    }
}
