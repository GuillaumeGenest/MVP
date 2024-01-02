//
//  Response.swift
//  MVP
//
//  Created by Guillaume Genest on 22/12/2023.
//

import Foundation


struct TicketInformationResponse: Decodable {
    let date: Date
    let urlPDF: String
    let value: Double
    // Ajoutez d'autres propriétés si nécessaire

    enum CodingKeys: String, CodingKey {
        case date
        case urlPDF
        case value
        // Ajoutez d'autres cas si nécessaire
    }
}

struct BusinessInformationResponse: Decodable {
    let id: String
    let name: String
    let logo: String
    let color: String
    // Ajoutez d'autres propriétés si nécessaire

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo
        case color
        // Ajoutez d'autres cas si nécessaire
    }
}

struct TicketResponse: Decodable {
    var tickets: TicketInformationResponse
    var business: BusinessInformationResponse
    
    enum CodingKeys: String, CodingKey {
        case tickets
        case business
    }
}
