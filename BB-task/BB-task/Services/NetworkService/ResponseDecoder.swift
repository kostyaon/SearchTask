//
//  ResponseDecoder.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

protocol ResponseDecoder {
    
    func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONResponseDecoder: ResponseDecoder {
    
    private let jsonDecoder = JSONDecoder()
    init() {}
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
