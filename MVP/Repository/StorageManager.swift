//
//  StorageManager.swift
//  MVP
//
//  Created by Guillaume Genest on 21/11/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit



final class StorageManager {
    
    private let storage = Storage.storage().reference()
    
    private var PDFReference: StorageReference {
        storage.child("tickets")
    }
    
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    func getPathForPDF(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    
    func getUrlForPDF(path: String) async throws -> URL {
        do {
            let url = try await getPathForPDF(path: path).downloadURL()
            return url
        } catch {
            throw StorageDatabaseError.getURLError
        }
    }
    
    func savePDF(data: Data, folderpath: String) async throws -> (path: String, name: String) {
        guard data.count > 0 else {
               print("Erreur : les données du PDF sont vides.")
               throw StorageDatabaseError.savePDFDataFailed
           }
           let meta = StorageMetadata()
           meta.contentType = "application/pdf"
           
           let path = "\(UUID().uuidString).pdf"

           let returnedMetaData = try await PDFReference.child(folderpath).child(path).putDataAsync(data, metadata: meta)
           
           guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
               print("Erreur putDataAsync")
               throw StorageDatabaseError.savePDFDataFailed
           }
           return (returnedPath, returnedName)
       }
}
