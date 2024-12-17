//
//  City.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/17/24.
//

import Foundation
import UIKit

struct City: Identifiable, Hashable {
    var id: String
    let name: String
    let temperature: Int
    let humidity: Int
    let uv: Int
    let feelslike: Int
    let imageURL: URL?
    var image: UIImage?
}
