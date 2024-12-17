//
//  CityCellView.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/17/24.
//

import SwiftUI

struct CityCellView: View {
    
    let city: City
    
    var body: some View {
        NavigationLink(value: city) {
            HStack {
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("\(city.temperature)°")
                        .font(.system(size: 50, weight: .semibold))
                }
                Spacer()
                Color.clear
                    .background(
                        ZStack(alignment: .trailing) {
                            image()
                            Color.clear
                        }
                    )
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.2))
            )
        }
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
    
}

#Preview {
    CityCellView(city: City(id: "123",
                            name: "London",
                            temperature: 25,
                            humidity: 20,
                            uv: 4,
                            feelslike: 38,
                            imageURL: URL(string: "city.imageURL")!
                            ))
}
