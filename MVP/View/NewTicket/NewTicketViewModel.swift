//
//  NewTicketViewModel.swift
//  MVP
//
//  Created by Guillaume Genest on 21/12/2023.
//

import Foundation
import UIKit
import PDFKit

class NewTicketViewModel: ObservableObject {
    let firebaserepository = FirestoreManager()
    
    let storageManager = StorageManager()
    
    
    @Published var urlPDFTicket: String = ""
    
    
    @Published var StatusMessage: String = ""
    @Published var DisplayErrorMessage: Bool = false
    @Published var isLoading: Bool = false
    
    
    @Published var ticketReceived: Bool = false
    @Published var isSuccess: Bool = false
    @Published var inProcess: Bool = false
    
    func addTickets(ticket: Ticket) async throws {
        
        do {
            try await firebaserepository.addTicket(ticket: ticket)
            self.isSuccess = true
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
    
    @MainActor
    func setError(_ error: Error) async {
        await MainActor.run {
            print(error.localizedDescription)
            StatusMessage = error.localizedDescription
            DisplayErrorMessage = true
        }
    }
    
    
}

extension NewTicketViewModel {
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
}
