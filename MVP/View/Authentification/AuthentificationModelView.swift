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
            throw AuthentificationError.NoEmailorPassword
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
            throw AuthentificationError.NoEmailorPassword
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
    
    func signOut() throws {
            try authentificationService.signOut()
    }
    
    func resetPassword(email: String){
        Task {
            do {
                try await authentificationService.resetPassword(email: email)
                self.StatusMessage = "Une demande de réinitialisation du mot de passe \na été envoyé à l'adresse suivante \(email)"
                self.DisplayErrorMessage.toggle()
            }
            catch {
                await setError(error)
            }
        }
    }
    
    func deleteAccount() async throws {
        try await authentificationService.delete()
        }
    
    @MainActor
    func signInWithGoogle() async throws {
        do {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await authentificationService.signInWithGoogle(tokens: tokens)
        let userID = authDataResult.uid
        self.isLoading = true
        let userExists = try await usermanager.CheckIfUserExist(with: userID)
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
    func signUpWithApple() async throws {
        self.isLoading.toggle()
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await authentificationService.signInWithApple(tokens: tokens)
        let userID = authDataResult.uid
        guard let name = tokens.name, !name.isEmpty else {
                try await deleteAccount()
                throw AuthentificationError.NameAppleError
        }
        do {
        let userExists = try await usermanager.CheckIfUserExist(with: userID)
            if userExists {
                print("L'utilisateur existe déjà: vous pouvez vous connectez  : \(AuthentificationError.userAlreadyExists.localizedDescription)")
                try signOut()
                throw AuthentificationError.userAlreadyExists
            }
            if !userExists {
                let newUser = UserModel(id: userID, name: tokens.name ?? "", email: authDataResult.email ?? "", imageURL: "")
                try await usermanager.createUser(user: newUser)
            }
        } catch {
            print("Erreur : \(error)")
            throw error
        }
        
    }
    
    @MainActor
    func signInWithApple() async throws {
        self.isLoading = true
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await authentificationService.signInWithApple(tokens: tokens)
        let userID = authDataResult.uid
        do {
            let userExists = try await usermanager.CheckIfUserExist(with: userID)
            if !userExists {
                guard let name = tokens.name, !name.isEmpty else {
                        try await deleteAccount()
                        throw AuthentificationError.userNotFound
                }
                print("Erreur lors de la vérification de l'utilisateur : \(AuthentificationError.errorUserIntheDatabase.localizedDescription)")
                let newUser = UserModel(id: userID, name: tokens.name ?? "Prénom", email: authDataResult.email ?? "", imageURL: "")
                try await usermanager.createUser(user: newUser)
                throw AuthentificationError.userNotFoundCreated
            }
        } catch {
            print("Erreur : \(error)")
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
    func isValidEmail(_ email: String, confirmationEmail: String) throws {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        let IsEmailsMatch = email == confirmationEmail
        
        guard isEmailValid else {
            throw AuthentificationError.invalidFormatEmail
        }
        
        guard IsEmailsMatch else {
            throw AuthentificationError.emailsDoNotMatch
        }
    }
}
