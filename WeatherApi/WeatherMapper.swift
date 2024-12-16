//
//  Untitled.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation

struct Weather: Codable {
    let location: Location?
    let current: Current?
}

enum LoadWeatherResult {
    case success(Weather)
    case failure(Error)
}

final class WeatherMapper {
    
    private static var OK_200: Int {return 200}
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> Weather {
        
        guard response.statusCode == OK_200,
              let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
            throw RemoteLoader.Error.invalidData
        }
        guard let location = weather.location, let current = weather.current else {
            throw RemoteLoader.Error.invalidData
        }
        
        return weather
    }
}

// MARK: - Current
struct Current: Codable {
    //let lastUpdatedEpoch: UInt8?
    let lastUpdated: String
    let tempC: Double
    /*let tempF, isDay: UInt8?
    let condition: Condition?
    let windMph: UInt8?
    let windKph: Double?
    let windDegree: UInt8?
    let windDir: String?
    let pressureMB: UInt8?
    let pressureIn: Double?
    let precipMm, precipIn, humidity, cloud: UInt8?
    let feelslikeC, feelslikeF, windchillC, windchillF: Double?
    let heatindexC: UInt8?
    let heatindexF, dewpointC: Double?
    let dewpointF, visKM, visMiles, uv: UInt8?
    let gustMph, gustKph: Double?*/

    enum CodingKeys: String, CodingKey {
        //case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        /*case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"*/
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String?
    let code: UInt8?
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: UInt8?
    let localtime: String?

    /*enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }*/
}
