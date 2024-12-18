//
//  ContentViewModel.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import Foundation
import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    
    private let weatherService: WeatherServiceProtocol
    @Published var cities: [City] = []
    @Published var selectedCity: City?
    
    @Published var searchText: String = ""
    @Published var error = false
    
    private let dataService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    
    @AppStorage("selectedCity") var selectedCityId = "" 
    
    init(_ weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        addSubscribers()
        if !selectedCityId.isEmpty {
            setSelectedCity(cityId: selectedCityId)
        }
    }
    
    func setSelectedCity(cityId: String) {
        self.selectedCityId = cityId
        self.weatherService.weatherFor(cityId: cityId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.error = false
                case .failure(let receivedError):
                    print("Received an error: \(receivedError)")
                    self?.error = true
                }
            } receiveValue: { [weak self] city in
                self?.selectedCity = city
            }
            .store(in: &cancellables)
    }
    
    func fetch(searchText: String) {
        cancellable = dataService.searchCities(searchText: searchText)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.error = false
                case .failure(let receivedError):
                    print("Received an error: \(receivedError)")
                    self.error = true
                }
            } receiveValue: { cities in
                self.cities = cities
            }
    }
    
    func addSubscribers() {
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { self.fetch(searchText: $0) }
            .store(in: &cancellables)
    }
    
}
