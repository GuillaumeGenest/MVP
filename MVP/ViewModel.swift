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
    let firebaserepository = FirestoreManager()
    
    let storageManager = StorageManager()
    
    
    @Published var StatusMessage: String = ""
    @Published var DisplayErrorMessage: Bool = false
    @Published var isLoading: Bool = false
    
    
    @Published var isSuccess: Bool = false
    
    
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
            self.isSuccess = true
        }
        catch {
            throw error
        }
    }
    
    
    func deleteTickets(ticket: Ticket) async throws {
        do {
            
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


extension ViewModel {
    func regeneratePDFData(from capturedImage: UIImage) throws -> Data {
        let pdfDocument = PDFDocument()

        guard let pdfPage = PDFPage(image: capturedImage) else {
            throw StorageDatabaseError.PDFCreationFailed
        }

        pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)

        guard let pdfData = pdfDocument.dataRepresentation() else {
            throw StorageDatabaseError.PDFCreationFailed
        }
        return pdfData
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
    
    
    func SharePdf(url: URL){
        
    }
}
