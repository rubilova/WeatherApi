//
//  ContentView.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import SwiftUI
import Combine

struct ContentView: View {

    @State var searchText = ""
    @StateObject var viewModel = ContentViewModel()
    //let searchTextPublisher = PassthroughSubject<String, Never>()
       
    var body: some View {
        NavigationView {
            if let weather = viewModel.weather {
                VStack {
                    Text(weather.location?.name ?? "no valid city found")
                    if let current = weather.current {
                        Text(String(format: "%.0f", current.tempC))
                    }
                }
            } else {
                Text("type a city name")
            }
        }
        .searchable(text: $viewModel.searchText)
        /*.onChange(of: searchText) { searchText in
            searchTextPublisher.send(searchText)
        }
        .onReceive(
            searchTextPublisher
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        ) { _ in
            //$viewModel.getWeather(debouncedSearchText)
        }*/
    }
}

#Preview {
    ContentView()
}
