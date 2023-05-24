//
//  TrieNode.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

class TrieNode<Key: Hashable> {
    
    var key: Key?
    weak var parent: TrieNode?
    var children: [Key: TrieNode] = [:]
    
    var isTerminating = false
    
    init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}
