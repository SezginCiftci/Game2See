//
//  Date+Extension.swift
//  Game2See
//
//  Created by Sezgin Çiftci on 29.12.2022.
//

import Foundation

extension String {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self) 
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date ?? .now)
    }
}
