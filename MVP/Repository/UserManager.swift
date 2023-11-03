//
//  UserManager.swift
//  MVP
//
//  Created by Guillaume Genest on 27/10/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager: ObservableObject{
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
   
      
    init() {}
    
    private func userDocument(userId: String) -> DocumentReference {
          userCollection.document(userId)
      }
    
    func createUser(user: UserModel) async throws {
        do {
            try userDocument(userId: user.id).setData(from: user, merge: false)
        } catch {
            throw AuthentificationError.userAlreadyExists
        }
    }
}





extension UserManager {
    func CheckIfUserExist(with userID: String) async throws -> Bool {
        do {
            let documentSnapshot = try await userDocument(userId: userID).getDocument()
            return documentSnapshot.exists
        } catch {
            throw error
        }
    }
}
