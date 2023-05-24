//
//  Trie.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

class Trie<CollectionType: Collection> where CollectionType.Element: Hashable {
    
    typealias Node = TrieNode<CollectionType.Element>
    
    let root = Node(key: nil, parent: nil)
    
    init() {}
    
    func insert(_ collection: CollectionType, id: Int) {
        var current = root
        
        for element in collection {
            if current.children[element] == nil {
                current.children[element] = Node(key: element, parent: current)
            }
            current = current.children[element]!
        }
        
        current.isTerminating = true
        current.nodeIDs.append(id)
    }
    
    func contains(_ collection: CollectionType) -> Bool {
        var current = root
        for element in collection {
            guard let child = current.children[element] else { return false }
            current = child
        }
        return current.isTerminating
    }
    
    func remove(_ collection: CollectionType) {
        var current = root
        for element in collection {
            guard let child = current.children[element] else {
                return
            }
            current = child
        }
        guard current.isTerminating else { return }
        current.isTerminating = false
        current.nodeIDs = []
        while let parent = current.parent, current.children.isEmpty && !current.isTerminating {
            parent.children[current.key!] = nil
            current = parent
        }
    }
}

// Prefix matching
extension Trie where CollectionType: RangeReplaceableCollection {
    
    func collections(startingWith prefix: CollectionType) -> [Int] {
        var current = root
        for element in prefix {
            guard let child = current.children[element] else { return [] }
            current = child
        }
        return collections(startingWith: prefix, after: current)
    }
}

// Private
private
extension Trie where CollectionType: RangeReplaceableCollection {
    
    func collections(startingWith prefix: CollectionType, after node: Node) -> [Int] {
        var results: [Int] = []
        
        if node.isTerminating {
            results += node.nodeIDs
        }
        
        for child in node.children.values {
            var prefix = prefix
            prefix.append(child.key!)
            results += collections(startingWith: prefix, after: child)
        }
        
        return results
    }
    
}
