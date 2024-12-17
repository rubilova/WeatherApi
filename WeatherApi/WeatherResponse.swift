//
//  Untitled.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation

struct CitySearchResponse: Decodable {
    let id: Int
}

struct CityDetailsResponse: Decodable {
    let q: String
    let location: Location
    let current: Current
    func toCity() -> City {
        City(id: q,
             name: location.name,
             temperature: Int(current.temp_c),
             humidity: Int(current.humidity),
             uv: Int(current.uv),
             feelslike: Int(current.feelslike_c),
             imageURL: imageURL()
             )
    }
    private func imageURL() -> URL? {
        let url = "https:" + current.condition.icon.replacingOccurrences(of: "64x64", with: "128x128")
        return URL(string: url)
    }
}

struct Location: Decodable {
    let name: String
}

struct Current: Decodable {
    let temp_c: Double
    let humidity: Double
    let uv: Double
    let feelslike_c: Double
    let condition: Condition
}

struct Condition: Decodable {
    let icon: String
}

struct CitiesResponse: Decodable {
    let bulk: [CityQueryResponse]
}

struct CityQueryResponse: Decodable {
    let query: CityDetailsResponse
}
