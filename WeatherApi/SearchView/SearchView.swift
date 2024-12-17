//
//  ContentView.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/16/24.
//

import SwiftUI
import Combine

struct SearchView: View {

    @StateObject var viewModel = SearchViewModel()
    
       
    var body: some View {
        NavigationStack {
            content()
                .searchable(text: $viewModel.searchText, prompt: "Search Location")
        }
        .searchable(text: $viewModel.searchText)
        
    }
    
    @ViewBuilder
    func content() -> some View {
        ZStack {
            if viewModel.error {
                error()
            } else if viewModel.cities.isEmpty {
                error()
                //emptyPlaceholder()
            } else {
                citiesList()
            }
        }
            .animation(.default, value: viewModel.cities)
    }
    
    func emptyPlaceholder() -> some View {
        VStack {
            Text("No City Selected")
                .font(.title)
                .fontWeight(.bold)
            Text("Please Search For A City")
        }
    }
    
    func citiesList() -> some View {
        ScrollView(.vertical) {
            ForEach(viewModel.cities) { city in
                CityCellView(city: city)
                    .contentShape(Rectangle())
            }
                .padding()
        }
    }
    

    func error() -> some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(Color.orange)
                .font(.system(size: 80))
                .padding(5)
            Text("Couldn't retrieve data for selected location.")
            Text("Please try again later.")
        }
    }
}

#Preview {
    SearchView()
}
