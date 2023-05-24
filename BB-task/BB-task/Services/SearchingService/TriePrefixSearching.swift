//
//  TriePrefixSearching.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

struct TriePrefixSearching<T: Collection>: Searchable where T: RangeReplaceableCollection, T.Element: Hashable {

    private let collection: [(T, Int)]
    private var trie = Trie<T>()
    
    init(_ collection: [(T, Int)]) {
        self.collection = collection
        self.createTrie()
    }
    
    func searchFor(prefix: T) -> [Int] {
        return trie.collections(startingWith: prefix)
    }
}

private
extension TriePrefixSearching {
    
    func createTrie() {
        for element in collection {
            trie.insert(element.0, id: element.1)
        }
    }
}
