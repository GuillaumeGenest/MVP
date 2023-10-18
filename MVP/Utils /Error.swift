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
