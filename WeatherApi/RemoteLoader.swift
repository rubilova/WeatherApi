//
//  RemoteLoader.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation

public class RemoteLoader: WeatherLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    //public typealias Result = LoadWeatherResult
    
    public init(url: URL, client: HTTPClient){
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (LoadWeatherResult) -> Void ) {
        client.get(from: url, completion: { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
                case let .success(data, response):
                    completion(RemoteLoader.map(data, from: response))
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        })
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse)  -> LoadWeatherResult {
        do {
            let items = try WeatherMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
