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
    
    case noResponse
    case parsing(Error)
    case networkError(Error)
}

final class NetworkService {
    
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    typealias ResponseCompletionHandler<T> = (Result<T, NetworkError>) -> Void
    
    private let configuration: NetworkConfigurable
    
    public init(config: NetworkConfigurable) {
        self.configuration = config
    }
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping ResponseCompletionHandler<T>) where E.Response == T {
        request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, NetworkError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async {
                    completion(result)
                }
            case .failure(let error):
                let error: NetworkError = .networkError(error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

private
extension NetworkService {
    
    func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, NetworkError> {
        do {
            guard let data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(NetworkError.urlGeneration))
        }
    }
    
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
