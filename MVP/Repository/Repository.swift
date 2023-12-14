//
//  Repository.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject{
    let db = Firestore.firestore()
    private let ticketsCollection: CollectionReference = Firestore.firestore().collection("tickets")
    init() {}
    
    
    
    func fetchTickets() async throws -> [Ticket] {
        var tickets: [Ticket] = []
        do {
            let querySnapshot = try await ticketsCollection.getDocuments()
            for document in querySnapshot.documents {
                if let ticketData = try? document.data(as: Ticket.self) {
                            tickets.append(ticketData)
                }
            }
                    return tickets
        } catch {
            throw FirebaseDatabaseError.getDataError
        }
    }
    
    func addTicket(ticket: Ticket) async throws {
        do {
            let documentReference = ticketsCollection.document(ticket.id.uuidString)
            let ticketData = try Firestore.Encoder().encode(ticket)
            try await documentReference.setData(ticketData)
        } catch {
            throw FirebaseDatabaseError.jsonEncodingFailed
        }
    }
    
    
    func deleteTicket(ticket: Ticket) async throws {
        do {
            let documentReference = ticketsCollection.document(ticket.id.uuidString)
            try await documentReference.delete()
        } catch {
            throw error
        }
    }
}
