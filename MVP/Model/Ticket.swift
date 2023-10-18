//
//  Ticket.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import SwiftUI


class Ticket: Identifiable, ObservableObject, Equatable ,Codable {
    @Published var id = UUID()
    @Published var date: Date
    @Published var urlPDF : URL
    
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), date: Date, urlPDF: URL) {
        self.id = id
        self.date = date
        self.urlPDF = urlPDF
    }
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case urlPDF
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.urlPDF = try container.decode(URL.self, forKey: .urlPDF)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(urlPDF, forKey: .urlPDF)
        
    }
}
 
let previewTicket = [Ticket(date: Date(), urlPDF: URL(string: "https://firebasestorage.googleapis.com/v0/b/mvp-ticket.appspot.com/o/Devis_20230921.pdf?alt=media&token=d73114df-166d-4635-8e2d-18781cad62a3&_gl=1*f0iv7e*_ga*ODk0NzAwMjcyLjE2OTc0NDc1NjQ.*_ga_CW55HF8NVT*MTY5NzYyNzI1OS4xMS4xLjE2OTc2Mjc4OTYuMzUuMC4w")!),
    Ticket(date: Date(timeIntervalSinceNow: -24*60*60*8), urlPDF: URL(string: "https://firebasestorage.googleapis.com/v0/b/mvp-ticket.appspot.com/o/AnnexeA_20230921.pdf?alt=media&token=01cc8c5d-3a3e-477b-9679-ce94f773a2f6&_gl=1*1wsby9q*_ga*ODk0NzAwMjcyLjE2OTc0NDc1NjQ.*_ga_CW55HF8NVT*MTY5NzYyNzI1OS4xMS4xLjE2OTc2Mjc4OTQuMzcuMC4w")!)
]
