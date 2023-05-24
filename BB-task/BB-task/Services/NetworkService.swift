//
//  NetworkService.swift
//  BB-task
//
//  Created by KonstanTanos on 23/05/2023.
//

import Foundation

enum NetworkError: Error {
    
    case error(statusCode: Int, data: Data?)
    case notConnected
    case generic(Error)
    case urlComponents
    case urlGeneration
}


final class NetworkService {
    
    typealias CompletionHandler = (Result<Data?, Error>) -> Void
    
    private let configuration: NetworkConfigurable
    
    public init(config: NetworkConfigurable) {
        self.configuration = config
    }
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(NetworkError.urlGeneration))
        }
    }
}

private
extension NetworkService {
    
    func request(request: URLRequest, completion: @escaping CompletionHandler) {
        let task = URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = NetworkError.error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.handleError(error: requestError)
                }
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    func handleError(error: Error) -> NetworkError {
        let errorCode = URLError.Code(rawValue: (error as NSError).code)
        switch errorCode {
        case .notConnectedToInternet:
            return .notConnected
        default:
            return .generic(error)
        }
    }
}
