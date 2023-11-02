//
//  AuthentificationService.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthentificationService: ObservableObject{
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        return providers
    }
}


extension AuthentificationService {
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        }catch {
            throw AuthentificationError.userNotFoundCreated
        }
    }
    
    
    @discardableResult
       func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
           do {
               let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
               return AuthDataResultModel(user: authDataResult.user)
           } catch{
               throw AuthentificationError.userNotFound
           }
       }
       
    
    
}



struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}
