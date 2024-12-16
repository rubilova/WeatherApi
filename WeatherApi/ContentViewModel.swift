//
//  ContentViewModel.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var weather: Weather?
    @Published var searchText: String = ""
    
    private let dataService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText.sink{ [weak self] (searchString) in
            guard !searchString.isEmpty else { return }
            print(searchString)
            self?.dataService.getWeather(city: searchString)
        }
        .store(in: &cancellables)
        
        dataService.$weather
            .sink{[weak self] (returnedWeather) in
                self?.weather = returnedWeather
            }
            .store(in: &cancellables)
    }
}
