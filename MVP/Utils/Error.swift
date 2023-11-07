//
//  Error.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation

enum FirebaseDatabaseError: Error, LocalizedError {
    case jsonEncodingFailed
    case dictionaryConversionFailed
    case databaseUpdateFailed
    case removevalueFailed
    case userNotFound
    case userNotconnected
    case getDataError
    var errorDescription: String? {
        switch self {
        case .jsonEncodingFailed:
            return "Erreur lors de l'encodage JSON."
        case .dictionaryConversionFailed:
            return "Erreur lors de la conversion du JSON en dictionnaire."
        case .databaseUpdateFailed:
            return "Erreur lors de la mise à jour des données de l'utilisateur dans la base de données."
        case .removevalueFailed:
            return "Erreur lors de la suppression des données"
        case .userNotFound:
            return "Erreur l'utilisateur n'est pas dans la base "
        case .userNotconnected:
            return "L'utilisateur n'est pas connecté"
        case .getDataError:
            return "Erreur dans la récupération des données sur le serveur "
        }
    }
}


enum StorageDatabaseError: Error, LocalizedError {
    case downloadDatafromStorageFailed
    case saveImagedateFailed
    case getURLError
    var errorDescription: String? {
        switch self {
        case .downloadDatafromStorageFailed:
            return "Erreur dans le téléchargement des données depuis Firebase Storage"
        case .saveImagedateFailed:
            return "Erreur metada lors de la sauvegarde de l'image"
        case .getURLError:
            return "Impossible de retourner l'url"
        }
    }
}

enum AuthentificationError: Error, LocalizedError {
    case UserIsNotConnected
    case userAlreadyExists
    case NoEmailorPassword
    case userNotFound
    case errorCheckUser
    case errorUserIntheDatabase
    case userNotFoundCreated
    case NameAppleError
    var errorDescription: String? {
        switch self {
        case .UserIsNotConnected:
            return "L'utilisateur n'est pas connecté "
        case .userAlreadyExists:
            return "L'adressse email est déjà utilisée par un autre utilisateur \n Connectez vous avec cette adresse email"
        case .NoEmailorPassword:
            return "Aucun email ou mot de passe "
        case .userNotFound:
            return "Cet utilisateur n'existe pas, veuillez vous enregistrer"
        case .userNotFoundCreated:
            return " Cet utilisateur n'existe pas, il a été créé \n Vous pouvez supprimer votre compte en allant de Profil > Mon Compte > Supprimer ce compte"
        case .errorCheckUser:
            return "Une erreur dans la vérification d'authentification s'est produite"
        case .errorUserIntheDatabase:
            return "Une erreur s'est produite dans la base de données \n Veuillez contacter le support \n contact@sunnyonroads.com"
        case .NameAppleError:
            return "Vous avez déjà utilisé l'authentification avec Apple.\nPour vous connecter avec ce compte, allez dans Réglages > Identifiant Apple > Mot de passe et sécurité.\nSélectionnez 'Connexion avec Apple' > SunnyOnRoads > Arrêter d'utiliser l'identifiant Apple."
        }
    }
}




//enum AuthenticationError: Error {
//    case invalidName
//    case invalidPassword
//    case userDisabled
//    case emailAlreadyInUse
//    case invalidEmail
//    case wrongPassword
//    case userNotFound
//    case accountExistsWithDifferentCredential
//    case networkError
//    case credentialAlreadyInUse
//    case unknown
//
//    init(rawValue: Int) {
//        switch rawValue {
//        case 17005: self = .userDisabled
//        case 17007: self = .emailAlreadyInUse
//        case 17008: self = .invalidEmail
//        case 17009: self = .wrongPassword
//        case 17011: self = .userNotFound
//        case 17012: self = .accountExistsWithDifferentCredential
//        case 17020: self = .networkError
//        case 17025: self = .credentialAlreadyInUse
//        case 17026: self = .invalidPassword
//        default: self = .unknown
//        }
//    }
//}
