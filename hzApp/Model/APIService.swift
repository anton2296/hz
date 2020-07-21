//
//  API.swift
//  hzApp
//
//  Created by serg Kh on 20.07.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation

enum APIEndpoint {
    case sample
}

private extension APIEndpoint {
    var path : String {
        switch self {
        case .sample : return "/static/json/sample.json"
        }
    }
}

enum ApiLoadingError: Error {
    case noInternet // Нет сети, например NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotConnectToHost
    case serviceUnavailable // Сервер вернул 500 или 503
    case unknown // Все остальные ошибки
    case cancelled
}

extension ApiLoadingError {
    var localizedDescription : String {
        switch self {
        case .noInternet : return "No internet"
        case .serviceUnavailable : return "Service unavailable"
        case .unknown : return "Unknown error"
        case .cancelled : return "Cancelled"
        }
    }
}

final class APIService {
    private let domain: String
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(domain: String) {
        self.domain = domain
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    private func createURLRequest(apiEndpoint: APIEndpoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = domain
        urlComponents.path = apiEndpoint.path
        guard let url = urlComponents.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func parseResponseData<T:Decodable>(responseData: Data) -> Result<T, Error> {
        do {
            let dataObject = try self.decoder.decode(T.self, from:
                responseData)
            return .success(dataObject)
        } catch {
            return .failure(ApiLoadingError.unknown)
        }
    }
    
    func getData<T:Decodable>(apiEndpoint: APIEndpoint, handler: @escaping (Result<T, Error>) -> Void){
        guard let urlRequest = createURLRequest(apiEndpoint: apiEndpoint) else {
            handler(.failure(ApiLoadingError.unknown))
            return
        }
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 500 && httpResponse.statusCode == 503 {
                    handler(.failure(ApiLoadingError.serviceUnavailable))
                    return
                }
            }
            if error != nil {
                switch (error! as NSError).code {
                case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotConnectToHost:
                    handler(.failure(ApiLoadingError.noInternet))
                case NSURLErrorCancelled:
                    handler(.failure(ApiLoadingError.cancelled))
                default:
                    handler(.failure(ApiLoadingError.unknown))
                }
                return
            }
            guard let responseData = data else {
                handler(.failure(ApiLoadingError.unknown))
                return
            }
            handler(self.parseResponseData(responseData: responseData))
        }
        task.resume()
    }
}

