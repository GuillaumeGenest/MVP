//
//  SettingsModelView.swift
//  MVP
//
//  Created by Guillaume Genest on 07/11/2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var authentificationService = AuthentificationService()
    @Published var authProviders: [AuthProviderOption] = []
    @Published var usermanager = UserManager()
    
    @Published private(set) var user: UserModel? = nil

    
//    @Published var StatusMessage: String = ""
//    @Published var DisplayErrorMessage: Bool = false
//    @Published var isLoading: Bool = false
//    
//

    
    func loadAuthProviders() {
            if let providers = try? authentificationService.getProviders() {
                authProviders = providers
            }
        }
    
    func loadCurrentUser() async throws {
        
        do {
            let authDataResult = try authentificationService.getAuthenticatedUser()
            self.user = try await usermanager.getUser(userId: authDataResult.uid)
        } catch {
            print(error)
        }
       }
    
    
    func signOut() throws {
            try authentificationService.signOut()
    }
//        
//        func deleteAccount() async throws {
//            try await authentificationService.delete()
//        }
//        
//        func resetPassword() async throws {
//            let authUser = try authentificationService.getAuthenticatedUser()
//            
//            guard let email = authUser.email else {
//                throw URLError(.fileDoesNotExist)
//            }
//            
//            try await authentificationService.resetPassword(email: email)
//        }
//        
//        func updateEmail() async throws {
//            let email = "hello123@gmail.com"
//            try await AuthenticationManager.shared.updateEmail(email: email)
//        }
//        
//        func updatePassword() async throws {
//            let password = "Hello123!"
//            try await AuthenticationManager.shared.updatePassword(password: password)
//        }
//    
//    
//    func updatepassworduser(oldPassword: String, newPassword: String){
//        authentificationService.changePassword(oldPassword: oldPassword, newPassword: newPassword){ (results) in
//            switch results {
//            case .success(let data):
//                if data == true {
//                    self.StatusMessage = "Password a été changé avec success "
//                    self.DisplayErrorMessage.toggle()
//                }
//            case .failure(let error):
//                print(error)
//                self.StatusMessage = error.localizedDescription.description
//                self.DisplayErrorMessage.toggle()
//            }
//        }
//    }
//    
//    
////
////    func UpdateUser(with information : UserModel){
////        firebaseRepository.UpdateUserInTheDatabase(information: information) { (results) in
////            switch results {
////            case .success(let data):
////                if data == true {
////                    print("User information updated")
////                }
////            case .failure(let error):
////                print(error)
////                self.StatusMessage = error.localizedDescription.description
////                self.DisplayErrorMessage.toggle()
////            }
////        }
////    }
//    
//    func RemoveImage(from url : String){
//        firebaseRepository.RemoveImage(from: url){ (results) in
//            switch results {
//            case .success(let data):
//                if data == true {
//                    print("Image removed from Firebase ")
//                }
//            case .failure(let error):
//                print(error)
//                self.StatusMessage = error.localizedDescription.description
//                self.DisplayErrorMessage.toggle()
//            }
//        }
//    }
//    
//    func deleteProfileImage(userId: String, url: String) {
//        Task{
//            do {
//                print("delete Profile image ")
//                try await storagemanager.deleteImage(url: url)
////                try await firebaseRepository.UpdateImageProfileURL(url: url, UserId: userId)
//                print("SUCCESS")
//            }
//            catch {
//                
//                await setError(error)
//            }
//        }
//    }
//    
//    
//    func DeleteUserAccount(userId: String, url: String) async throws {
//        print("SUPPRESSION COMPTE")
//        print("Delete user account \(userId)")
//        if url.hasPrefix("https://firebasestorage.googleapis.com") {
//            print("remove image from storage")
//            try await storagemanager.deleteImage(url: url)
//        }
//        try await firebaseRepository.RemoveUser(userId: userId)
//        try await authentificationService.RemoveUser()
//        
//    }
//    
//    
////    func deleteUserAccount(user: UserModel){
////        print("SUPPRESSION COMPTE")
////        print("Delete user account \(user.id)")
////        if user.imageURL != ""{
////            RemoveImage(from: user.imageURL)
////        }
////        print("function remove user")
////        firebaseRepository.RemoveUser(userId: user.id){ (results) in
////            if results == true {
////                print("result :\(results)")
////                self.authentificationService.RemoveUser(){ (results) in
////                    switch results {
////                        case .success(let data):
////                            if data == true {
////                                print("remove from authentification")
////
////                                print("User deleted from firebase")
////                                self.SignOut()
////                            }
////                        case .failure(let error):
////                            print(error)
////                            self.StatusMessage = error.localizedDescription.description
////                            self.DisplayErrorMessage.toggle()
////                    }
////                }
////            }
////            if results == false {
////                self.StatusMessage = "L'utilisateur n'est plus existant"
////                self.DisplayErrorMessage.toggle()
////                self.SignOut()
////            }
////        }
////
////    }
////
//    func SignOut(){
//        print("Deconnection")
//        authentificationService.signOut(){ (results) in
//            switch results {
//            case .success(let data):
//                if data == true {
//                    print("sucess signOut loginModelView")
//                }
//            case .failure(let error):
//                print(error)
//                self.StatusMessage = error.localizedDescription.description
//                self.DisplayErrorMessage.toggle()
//            }
//        }
//    }
//    
////    func loadImageData(userId: String, url: String) {
////            if !url.isEmpty && url.hasPrefix("https://firebasestorage.googleapis.com") {
////                Task {
////                let data = try await storagemanager.getData(userId: userId, path: url)
////            }
////        }
////        else {
////
////        }
////    }
//    
//    
//    
//    
//    func DownloadImagefromStorage(from url: String, completion:@escaping (Data) -> Void){
//        firebaseRepository.downloadImage(from: url){ (result) in
//            switch result{
//            case .success(let data):
//                completion(data)
//            case .failure(let error):
//                print(error)
//                self.isLoading.toggle()
//                self.StatusMessage = error.localizedDescription.description
//                self.DisplayErrorMessage.toggle()
//                
//            }
//        }
//    }
//    
//    func uploadImageprofil(userId : String, value: Data, completion: @escaping (String) -> Void){
//        firebaseRepository.UploadImageProfilOnFirebase(UserId: userId, value: value) { (result) in
//            switch result {
//            case .success(let data):
//                print(data)
//                completion(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//                self.StatusMessage = error.localizedDescription
//                self.DisplayErrorMessage.toggle()
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    func UpdateProfileUser() {
//        
//
//    }
//    
//    @MainActor
//    func setError(_ error: Error) async {
//        await MainActor.run {
//            StatusMessage = error.localizedDescription
//            DisplayErrorMessage = true
//        }
//    }
}
//
//
//protocol AuthentificationServiceProtocol {
//    func getProviders() throws -> [AuthProviderOption]
//}
//
//class MockedEmailAuthentificationService: AuthentificationServiceProtocol, ObservableObject {
//    func getProviders() throws -> [AuthProviderOption] {
//        return [.email]
//    }
//}
//
//class MockedAppleAuthentificationService: AuthentificationServiceProtocol, ObservableObject {
//    func getProviders() throws -> [AuthProviderOption] {
//        return [.apple]
//    }
//}

