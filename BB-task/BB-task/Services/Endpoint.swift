//
//  Endpoint.swift
//  BB-task
//
//  Created by KonstanTanos on 23/05/2023.
//

import Foundation

enum HTTPMethodType: String {
    
    case get = "GET"
}

protocol Requestable {
    
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParameters: [String: Any] { get }
    
    func urlRequest(with networkConfiguration: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    
    associatedtype Response
    var responseDecoder: ResponseDecoder { get }
}

extension Requestable {
    
    func url(with networkConfiguration: NetworkConfigurable) throws -> URL {
        let baseURL = networkConfiguration.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw NetworkError.urlComponents
        }
        var urlQueryItems: [URLQueryItem] = []
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        networkConfiguration.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { throw NetworkError.urlComponents }
        return url
    }
    
    func urlRequest(with networkConfiguration: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: networkConfiguration)
        var urlRequest = URLRequest(url: url)
        var headers = networkConfiguration.headers
        headerParameters.forEach { headers.updateValue($1, forKey: $0) }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

class Endpoint<T>: ResponseRequestable {
    
    typealias Response = T
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParameters: [String: Any]
    let responseDecoder: ResponseDecoder
    
    init(path: String, isFullPath: Bool = false, method: HTTPMethodType, headerParameters: [String : String] = [:], queryParameters: [String : Any] = [:], responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParameters = queryParameters
        self.responseDecoder = responseDecoder
    }
}


