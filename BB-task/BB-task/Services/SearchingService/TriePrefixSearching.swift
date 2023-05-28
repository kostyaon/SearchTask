//
//  TriePrefixSearching.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

struct TriePrefixSearching: Searchable {
    
    private let trie = Trie<String>()
    
    init() { }
    
    func searchFor(prefix: String) -> [Int] {
        return trie.collections(startingWith: prefix)
    }
    
    func isEmpty() -> Bool {
        trie.isEmpty
    }
    
    func createTrie(from dictionary: Dictionary<Int, String>, completion: @escaping () -> ())  {
        dictionary.forEach {
            trie.insert($0.value, id: $0.key)
        }
        completion()
    }
}
