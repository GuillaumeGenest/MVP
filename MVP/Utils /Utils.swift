//
//  Utils.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
extension Date {
    
    func FormattedDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
        
    }
    
}
