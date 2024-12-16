//
//  WeatherService.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation
import Combine

class WeatherService {
    
    @Published var weather: Weather?
    
    var weatherSubscription: AnyCancellable?
    private let apiKey = "b38026405298410697632906241612"
    
    /*init() {
     getWeather()
     }*/
    
    func getWeather(city: String) {
        guard let url = URL(string: "http://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)&aqi=no") else { return }
        
        weatherSubscription = NetworkingManager.download(url: url)
            .decode(type: Weather.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedWeather) in
                self?.weather = returnedWeather
                self?.weatherSubscription?.cancel()
            })
    }
}
