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
                case .failure:
                    self?.error = true
                }
            } receiveValue: { [weak self] city in
                self?.selectedCity = city
            }
            .store(in: &cancellables)
    }
    
    func addSubscribers() {
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { [weak self] searchText -> AnyPublisher<[City], Error> in
                guard let self = self else { return Fail(error: RemoteError.connectivity).eraseToAnyPublisher() }
                return self.weatherService.searchCities(searchText: searchText)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.error = false
                case .failure:
                    self?.error = true
                }
            } receiveValue: { [weak self] cities in
                self?.cities = cities
            }
            .store(in: &cancellables)
    }
    
}
