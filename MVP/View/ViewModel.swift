//
//  ViewModel.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import UIKit
import PDFKit
import SwiftUI


class ViewModel: ObservableObject {
    @Published var tickets = [Ticket]()
    @Published var business = [Business]()
    let firebaserepository = FirestoreManager()
    @Published var listofIdtickets = [String]()
    let storageManager = StorageManager()
    
    @Published var businessInfo: [String: Business] = [:]
    @Published var ticketInfo : [String: Ticket] = [:]
    
    @Published var StatusMessage: String = ""
    @Published var DisplayErrorMessage: Bool = false
    @Published var isLoading: Bool = false
    
    
    @Published var ticketReceived: Bool = false 
    @Published var isSuccess: Bool = false
    @Published var inProcess: Bool = false
    
    
    
    @State var SaveNewTicket: Bool = false
    
    
    @MainActor
    func setError(_ error: Error) async {
        await MainActor.run {
            print(error.localizedDescription)
            StatusMessage = error.localizedDescription
            DisplayErrorMessage = true
        }
    }
    

    @MainActor
    func fetchTest() async throws {
        do {
            let ticketResponse = try await firebaserepository.getResponse()

            for (id, response) in ticketResponse {
                // Utilisez le mapper pour convertir la réponse en modèles Ticket et Business
                let mappedResult = Mapper.mapResponseToTicketAndBusinesswithkey(id, response: response)
                    // Mettez à jour les valeurs dans les tableaux appropriés
                    ticketInfo[id] = mappedResult.ticket
                    businessInfo[id] = mappedResult.business
            }
        } catch {
            throw error
        }
    }
    
    
    func addTickets(ticket: Ticket) async throws {
        do {
            try await firebaserepository.addTicket(ticket: ticket)
            tickets.append(ticket)
            self.isSuccess = true
        }
        catch {
            throw error
        }
    }
    
    
    func deleteTickets(ticket: Ticket) async throws {
        do {
            try await firebaserepository.deleteTicket(ticket: ticket)
            if let index = self.tickets.firstIndex(of: ticket) {
                tickets.remove(at: index)
            }
        }
        catch {
            throw error
        }
    }
    
    
    func getListBusinessName() async throws -> [String: String] {
        do {
            let listofbusinessName = try await firebaserepository.getBusinessName()
            return listofbusinessName
        } catch {
            // Gérer l'erreur (imprimer ou enregistrer le journal, etc.)
            throw error
        }
    }    
}


extension ViewModel {

    
    
    func SharePdf(url: URL){
        
    }
}
