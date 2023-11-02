//
//  AuthentificationModelView.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import Foundation



class AuthentificationModelView: ObservableObject {
    @Published var authentificationService = AuthentificationService()
    @Published var usermanager = UserManager()
    
    
    @Published var StatusMessage: String = ""
    @Published var DisplayErrorMessage: Bool = false
    @Published var isLoading: Bool = false
    
    
    
    func signInWithEmail(email: String, password: String) async throws{
        print("logIn d'un utilisateur")
        guard !email.isEmpty, !password.isEmpty else {
                   print("No email or password found.")
                   return
        }
        do {
            try await authentificationService.signInUser(email: email, password: password)
        }
        catch {
            
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String) async throws{
        print("Creation d'un utilisateur")
        guard !email.isEmpty, !password.isEmpty else {
                   print("No email or password found.")
                   return
        }
        do {
            let authDataResult = try await authentificationService.createUser(email: email, password: password)
            let newUser = UserModel(id: authDataResult.uid, name: name, email: authDataResult.email ?? "", imageURL: "")
            try await usermanager.createUser(user: newUser)
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
