//
//  Extensions.swift
//  WeatherApi
//
//  Created by Elena Rubilova on 12/17/24.
//

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
