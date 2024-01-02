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
import FirebaseAuth


protocol FirebaseProtocol {
    func getResponse() async throws -> [String: TicketResponse]
    func addTicket(ticket: Ticket) async throws
    func deleteTicket(ticket: Ticket) async throws
}



class FirestoreManager: ObservableObject, FirebaseProtocol{
    let db = Firestore.firestore()
    private let ticketsCollection: CollectionReference = Firestore.firestore().collection("tickets")
    private let businessCollection: CollectionReference = Firestore.firestore().collection("commercant")
    private let usersCollection: CollectionReference = Firestore.firestore().collection("users")
    init() {}
    
    
    func getResponse() async throws -> [String: TicketResponse] {
//            guard let currentUser = Auth.auth().currentUser else {
//                throw FirebaseDatabaseError.userNotconnected
//            }
            do {
                // Récupérer la liste des IDs des tickets de l'utilisateur
                let ticketIDs = try await getTicketIDs(forUserID: "XOTc956eMWN7SiDFZjUNMx4AW6U2")
                
                // Récupérer les informations des tickets
                let ticketInformationArray = try await getTicketsInfo(for: ticketIDs)
                let businessInformationArray = try await getBusinessInformation(forTicketIDs: ticketIDs)


                var combinedDictionary: [String: TicketResponse] = [:]
                for ticketID in ticketIDs {
                    if let ticketInfoResponse = ticketInformationArray[ticketID], let businessInfoResponse = businessInformationArray[ticketID] {
                        let combinedTicketResponse = TicketResponse(tickets: ticketInfoResponse, business: businessInfoResponse)
                        combinedDictionary[ticketID] = combinedTicketResponse
                    }
                }
                return combinedDictionary
            } catch {
                throw error
            }
        }
    
    
    
    func getTicketsInfo(for ticketIDs: [String]) async throws -> [String: TicketInformationResponse] {
        var tickets: [String: TicketInformationResponse] = [:]

        for ticketID in ticketIDs {
            do {
                let ticketDocumentSnapshot = try await ticketsCollection.document(ticketID).getDocument()

                if let ticketData = try? ticketDocumentSnapshot.data(as: TicketInformationResponse.self) {
                    tickets[ticketID] = ticketData
                } else {
                    throw FirebaseDatabaseError.getDataError
                }
            } catch {
                print("Erreur lors de la récupération du ticket avec l'ID \(ticketID): \(error)")
                throw TestDataFirestore.failedrecuperticketInfo
            }
        }

        return tickets
    }
    
//    func addTicket(ticket: Ticket) async throws {
//        guard let currentUser = Auth.auth().currentUser else { return }
//        do {
//            let userDocumentReference = usersCollection.document(currentUser.uid)
//            try await userDocumentReference.updateData(["ListTicketsId": ticket.id.uuidString])
//
//            let documentReference = ticketsCollection.document(ticket.id.uuidString)
//            let ticketData = try Firestore.Encoder().encode(ticket)
//            try await documentReference.setData(ticketData)
//        } catch {
//            throw FirebaseDatabaseError.jsonEncodingFailed
//        }
//    }
    
    
    
    
    func addTicket(ticket: Ticket) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        do {
            // Récupérer le document utilisateur
            let userDocumentReference = usersCollection.document(currentUser.uid)
            var existingTicketIds = try await userDocumentReference.getDocument().data()?["ListTicketsId"] as? [String] ?? []

            // Ajouter le nouvel ID au tableau
            existingTicketIds.append(ticket.id.uuidString)

            // Mettre à jour le document utilisateur avec le tableau mis à jour
            try await userDocumentReference.updateData(["ListTicketsId": existingTicketIds])

            // Mettre à jour le document de tickets avec les données du nouveau ticket
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
    

    func getBusinessName() async throws -> [String: String] {
        do {
            let businessesCollection = Firestore.firestore().collection("commercant")
            let querySnapshot = try await businessesCollection.getDocuments()

            var businessesDictionary: [String: String] = [:]

            for document in querySnapshot.documents {
                if let id = document["id"] as? String, let name = document["name"] as? String {
                    businessesDictionary[id] = name
                }
            }

            return businessesDictionary
        } catch {
            throw error
        }
    }
    
    private func getTicketIDs(forUserID userID: String) async throws -> [String] {
        do {
            let userDocumentSnapshot = try await usersCollection.document(userID).getDocument()
            guard let ticketIDs = userDocumentSnapshot.data()?["ListTicketsId"] as? [String] else {
                return []
            }
            return ticketIDs
            
        } catch {
            throw TestDataFirestore.failedrecuperlistId
        }
    }
    
   private func getBusinessInformation(from Id: String) async throws -> BusinessInformationResponse {
        do {
            let documentReference = Firestore.firestore().collection("commercant").document(Id)
            let document = try await documentReference.getDocument()
            
            if let businessData = try? document.data(as: BusinessInformationResponse.self) {
                return businessData
            } else {
                throw FirebaseDatabaseError.getDataError
            }
        } catch {
            throw error
        }
    }
    
    
    func getBusinessInformation(forTicketIDs ticketIDs: [String]) async throws -> [String: BusinessInformationResponse] {
        var businessInfoDict: [String: BusinessInformationResponse] = [:]

        for ticketID in ticketIDs {
            do {
                let ticketDocumentReference = ticketsCollection.document(ticketID)
                let ticketDocumentSnapshot = try await ticketDocumentReference.getDocument()

                guard let businessID = ticketDocumentSnapshot.data()?["BusinessId"] as? String else {
                    print("Erreur lors de la récupération du ticket avec l'ID \(ticketID): BusinessId non trouvé.")
                    throw TestDataFirestore.failedrecuperbusinessInfo  // Ignorer ce ticket et passer au suivant
                }
                let businessInfo = try await getBusinessInformation(from: businessID)
                businessInfoDict[ticketID] = businessInfo
            } catch {
                print("Erreur lors de la récupération du ticket avec l'ID \(ticketID): \(error)")
                throw TestDataFirestore.failedrecuperbusinessInfo
            }
        }

        return businessInfoDict
    }
    
}



