//
//  WeatherApiApp.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import SwiftUI

@main
struct WeatherApiApp: App {
    @StateObject var searchViewModel = SearchViewModel(WeatherService())
    
    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(searchViewModel)
        }
    }
}
