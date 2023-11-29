//
//  ViewModel.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation



class ViewModel: ObservableObject {
    @Published var tickets = [Ticket]()
    let firebaserepository = FirestoreManager()
    
    let storageManager = StorageManager()
    
    
    @Published var StatusMessage: String = ""
    @Published var DisplayErrorMessage: Bool = false
    @Published var isLoading: Bool = false
    
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
    
    
    func saveDataToPDF(TicketId: String, ticketvalue: Data) async throws -> String {
        //let forldpath = "\(TicketId)"
        do {
            let (path, _) = try await storageManager.savePDF(data: ticketvalue, folderpath: TicketId)
            let url = try await storageManager.getUrlForPDF(path: path)
            let urlString = url.absoluteString
            return urlString
        }
        catch {
            throw error
        }
    }
    
    
    
    @MainActor
    func setError(_ error: Error) async {
        await MainActor.run {
            print(error.localizedDescription)
            StatusMessage = error.localizedDescription
            DisplayErrorMessage = true
        }
    }
    
}
