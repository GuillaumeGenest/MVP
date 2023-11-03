//
//  AuthentificationModelView.swift
//  MVP
//
//  Created by Guillaume Genest on 26/10/2023.
//

import Foundation


@MainActor
final class AuthentificationModelView: ObservableObject {
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
            throw error
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
    func signInWithGoogle() async throws {
        do {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await authentificationService.signInWithGoogle(tokens: tokens)
        let userID = authDataResult.uid
        self.isLoading = true
        let userExists = try await usermanager.CheckIfUserExist(with: userID) // Utilise la fonction CheckIfUserExist de UserManager
        if !userExists {
        print("Erreur lors de la vérification de l'utilisateur : \(AuthentificationError.errorUserIntheDatabase.localizedDescription)")
            throw AuthentificationError.errorUserIntheDatabase
        }
        } catch {
            print("Erreur:  \(error)")
            throw error
        }
    }
    
    @MainActor
    func signUpWithGoogle() async throws {
        do {
            let helper = SignInGoogleHelper()
            let tokens = try await helper.signIn()
            let authDataResult = try await authentificationService.signUpWithGoogle(tokens: tokens)
            let userID = authDataResult.uid
            let newUser = UserModel(id: userID, name: tokens.name ?? "", email: authDataResult.email ?? "", imageURL: authDataResult.photoUrl ?? "")
            self.isLoading.toggle()
            try await usermanager.createUser(user: newUser)
        } catch {
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


extension AuthentificationModelView {
    
    
    
}
