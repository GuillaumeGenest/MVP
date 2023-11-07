//
//  MVPTests_UserManager_Test.swift
//  MVPTests
//
//  Created by Guillaume Genest on 07/11/2023.
//

import XCTest
import Firebase
import FirebaseFirestore
@testable import MVP

final class MVPTests_UserManager_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
    }

    func testCreateUserAndRetrieveFromDatabase() {
        let userManager = UserManager() // Remplacez YourUserManagerImplementation par la classe réelle de votre gestionnaire d'utilisateurs
        let user = UserModel(id: "123456789", name: "John Doe", email: "john@example.com", imageURL: "")
        Task {
            do {
                // Créez l'utilisateur
                try await userManager.createUser(user: user)
                
                // Récupérez l'utilisateur de la base de données
                let retrievedUser = try await userManager.getUserById(userId: "123456789")
                
                // Effectuez des assertions pour vérifier si les données récupérées sont identiques aux données créées
                XCTAssertNotNil(retrievedUser)
                XCTAssertEqual(retrievedUser?.id, "123", "L'ID de l'utilisateur n'est pas identique")
                XCTAssertEqual(retrievedUser?.name, "John Doe", "Le nom de l'utilisateur n'est pas identique")
                XCTAssertEqual(retrievedUser?.email, "john@example.com", "L'email de l'utilisateur n'est pas identique")
                // Ajoutez d'autres assertions pour les autres propriétés de UserModel
            } catch {
                XCTFail("La création ou la récupération de l'utilisateur a échoué : \(error)")
            }
        }
    }

}
