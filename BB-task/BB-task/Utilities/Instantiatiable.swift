//
//  Instantiatiable.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation
import UIKit

protocol Instantiatiable: NSObjectProtocol {
    
    associatedtype T
    static var fileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

extension Instantiatiable where Self: UIViewController {
    
    static var fileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = fileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let vc = storyboard.instantiateViewController(withIdentifier: fileName) as? Self else {
            fatalError("Failed to instantiate initial vc \(Self.self) from \(fileName) storyboard")
        }
        return vc
    }
}

