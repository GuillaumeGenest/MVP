//
//  AuthentificationService.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthentificationService: ObservableObject{
    
    
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
    
    
    func CheckIfEmailExists(UserEmail: String, completion: @escaping (Result<[String]?, Error>) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: UserEmail, completion: { signInMethods, error in
            if let error = error {
                completion(.failure(error))
            }
            if let signInMethods = signInMethods{
                completion(.success(signInMethods))
                
            }
        })
    }
    
    
    func signOut()  throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws {
          guard let user = Auth.auth().currentUser else {
              throw AuthentificationError.UserIsNotConnected
          }
          
          try await user.delete()
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

extension AuthentificationService {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        let userExists = try await checkUserExists(email: tokens.email ?? "")
        if !userExists {
            throw AuthentificationError.userAlreadyExists
        } else {
            return try await signIn(credential: credential)
        }
    }
    
    @discardableResult
    func signUpWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        let userExists = try await checkUserExists(email: tokens.email ?? "")
        if userExists {
            throw AuthentificationError.userAlreadyExists
        } else {
            return try await signIn(credential: credential)
        }
    }
    
    @discardableResult
        func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
            let credential =  OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: tokens.token, rawNonce: tokens.nonce)
            return try await signIn(credential: credential)
        }
}





extension AuthentificationService {
        func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().signIn(with: credential)
            return AuthDataResultModel(user: authDataResult.user)
        }
    
    
    @discardableResult
        func checkUserExists(email: String) async throws -> Bool {
            do {
                let signInMethods = try await Auth.auth().fetchSignInMethods(forEmail: email)
                return !signInMethods.isEmpty
            } catch {
                throw AuthentificationError.errorCheckUser
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
