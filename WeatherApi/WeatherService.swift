//
//  WeatherService.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func searchCities(searchText: String) -> AnyPublisher<[City], Error>
    func weatherFor(cityId: String) -> AnyPublisher<City?, Error>
}

class WeatherService: WeatherServiceProtocol {
    
    var weatherSubscription: AnyCancellable?
    private let apiKey = "apiKey"
    
    private enum Method: String {
        case search, current
    }
    
    func searchCities(searchText: String) -> AnyPublisher<[City], Error> {
        guard !searchText.isEmpty else {
            return Just([City]())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        guard let url = makeUrl(method: .search, query: searchText) else {
            print("Failed to create URL for \(searchText) request")
            return Fail(error: RemoteError.connectivity).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [CitySearchResponse].self, decoder: JSONDecoder())
            .map { self.fetch(citiesIDs: $0.map(\.id)) }
            .switchToLatest()
            .catch { error in
                return Fail(error: RemoteError.invalidData).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    

    func weatherFor(cityId: String) -> AnyPublisher<City?, Error>
    {
        let cityIdInt = Int(cityId) ?? 0
        guard cityIdInt != 0 else {
            print("Received an invalid city ID")
            return  Fail(error: RemoteError.invalidData).eraseToAnyPublisher()
        }
        return fetch(citiesIDs: [cityIdInt])
            .map { cities in
                return cities.first
            }.eraseToAnyPublisher()
    }
    
    private func fetch(citiesIDs: [Int]) -> AnyPublisher<[City], Error> {
        guard !citiesIDs.isEmpty else {
            return Just([City]())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        guard let url = makeUrl(method: .current, query: "bulk") else {
            print("Failed to create URL for cities request")
            return Fail(error: RemoteError.connectivity).eraseToAnyPublisher()
        }
        let ids = citiesIDs.map { "id:\($0)"}
        let payload = ["locations": ids.map { ["q": $0] }]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Failed to deserialize JSON data")
            return  Fail(error: RemoteError.invalidData).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CitiesResponse.self, decoder: JSONDecoder())
            .map { response in
                response.bulk.map { $0.query.toCity() }
            }
            .catch { error in
                return Fail(error: RemoteError.invalidData).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func makeUrl(method: Method, query: String) -> URL? {
        URL(string: "https://api.weatherapi.com/v1/\(method.rawValue).json?key=\(apiKey)&q=\(query)")
    }
}

enum RemoteError: Swift.Error {
    case connectivity
    case invalidData
}

