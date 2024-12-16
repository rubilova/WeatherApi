//
//  WeatherLoader.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//
import Foundation

protocol WeatherLoader {
    func load(completion: @escaping (LoadWeatherResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
