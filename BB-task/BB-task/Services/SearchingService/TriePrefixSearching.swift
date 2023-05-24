//
//  TriePrefixSearching.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

struct TriePrefixSearching<T: Collection>: Searchable where T: RangeReplaceableCollection, T.Element: Hashable {

    private let collection: [T]
    private var trie = Trie<T>()
    
    init(_ collection: [T]) {
        self.collection = collection
        self.createTrie()
    }
    
    func searchFor(prefix: T) -> [T] {
        return trie.collections(startingWith: prefix)
    }
}

private
extension TriePrefixSearching {
    
    func createTrie() {
        for element in collection {
            self.trie.insert(element)
        }
    }
}
