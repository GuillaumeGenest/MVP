//
//  ViewModel.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
@MainActor
class ViewModel: ObservableObject {
    @Published var tickets = [Ticket]()
    let firebaserepository = FirestoreManager()
    
    
    
    func fetchData() async {
        do {
            tickets = try await firebaserepository.fetchTickets()
        } catch {
        }
    }
    
    func addTickets(ticket: Ticket) async throws {
        do {
            try await firebaserepository.addTicket(ticket: ticket)
            tickets.append(ticket)
        }
        catch {
            throw error
        }
    }
}
