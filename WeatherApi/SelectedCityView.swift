//
//  SelectedCityView.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/17/24.
//

import SwiftUI

struct SelectedCityView: View {
    let city: City
    
    var body: some View {
        VStack {
            image()
                .frame(width: 150, height: 150)
            HStack {
                Text(city.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Image(systemName: "location.fill")
            }
            Text("\(city.temperature)°")
                .font(.system(size: 50, weight: .semibold))
            metrics()
            Spacer()
        }
            .padding(30)
    }
    
    func image() -> some View {
        AsyncImage(url: city.imageURL){ phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else if phase.error != nil {
                Color.clear
            } else {
                Color.clear
            }
        }
    }
    
    func metrics() -> some View {
        HStack {
            parameter(title: "Humidity", measurement: "\(city.humidity)%")
            Spacer()
            parameter(title: "UV", measurement: "\(city.uv)")
            Spacer()
            parameter(title: "Feels Like", measurement: "\(city.feelslike)°")
        }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2))
            )
    }
    
    func parameter(title: String, measurement: String) -> some View {
        VStack {
            Text(title)
                .foregroundStyle(.secondary)
            Text(measurement)
        }
    }
}

#Preview {
    SelectedCityView(city: City(id: "123",
                                name: "London",
                                temperature: 25,
                                humidity: 20,
                                uv: 4,
                                feelslike: 38,
                                imageURL: URL(string: "city.imageURL")!
                                ))
}
