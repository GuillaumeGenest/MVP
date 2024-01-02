//
//  Business.swift
//  MVP
//
//  Created by Guillaume Genest on 15/12/2023.
//

import Foundation



class Business: Identifiable, ObservableObject, Equatable ,Decodable {
    @Published var id = UUID()
    @Published var name : String
    @Published var logo: String
    @Published var color: String
    
    static func == (lhs: Business, rhs: Business) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), name: String, logo: String, color: String) {
        self.id = id
        self.name = name
        self.logo = logo
        self.color = color
        
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case logo
        case color

    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.logo = try container.decode(String.self, forKey: .logo)
        self.color = try container.decode(String.self, forKey: .color)
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(logo, forKey: .logo)
//
//    }
}


var mockedbussiness = [Business(name: "Décathlon", logo:"https://firebasestorage.googleapis.com/v0/b/mvp-ticket.appspot.com/o/Business%2Fdecathlon.png?alt=media&token=cc3b6fdf-2a0c-485c-9064-d422fbe14808", color: ""), Business(name: "Castorama", logo: "https://firebasestorage.googleapis.com/v0/b/mvp-ticket.appspot.com/o/Business%2Fcastorama.png?alt=media&token=7e10f9fa-6ca8-4828-aa28-86f414685de2", color: ""), Business(name: "Ikea", logo: "https://firebasestorage.googleapis.com/v0/b/mvp-ticket.appspot.com/o/Business%2Fikea.png?alt=media&token=afaac4f6-052d-403b-b0a9-c3108eabb9e7", color: "")]


struct BusinessInformation: Codable {
    var id: String
    var name: String
    var logo: String
    var color: String
}

