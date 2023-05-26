//
//  TriePrefixSearching.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

struct TriePrefixSearching: Searchable {
    
    private var trie = Trie<String>()
    
    init() { }
    
    mutating func searchFor(prefix: String, in dictionary: Dictionary<Int, String>) -> [Int] {
        if trie.isEmpty {
            createTrie(from: dictionary)
        }
        
        return trie.collections(startingWith: prefix)
    }
}

private
extension TriePrefixSearching {
    
    func createTrie(from dictionary: Dictionary<Int, String>)  {
        dictionary.forEach {
            trie.insert($0.value, id: $0.key)
        }
    }
}
