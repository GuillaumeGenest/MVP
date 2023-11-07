//
//  MVPTests_AuthentificationEmail_Test.swift
//  MVPTests
//
//  Created by Guillaume Genest on 06/11/2023.
//

import XCTest
import Firebase
import FirebaseAuth
@testable import MVP

final class MVPTests_Authentification_Test: XCTestCase {
    
    var authentificationService : AuthentificationService?
    private var testUserEmail: String = "unittest@example.com"
    private var testUserPassword: String = "password"
    
    override func setUpWithError() throws {
        super.setUp()
        authentificationService = AuthentificationService()
    }

    override func tearDownWithError() throws {
        test_AuthentificationModelView_DeleteUser()
        authentificationService = nil
        super.tearDown()
    }
    
    
    func test_AuthentificationModelView_DeleteUser() {
        Task {
            do {
                try await authentificationService!.delete()
            } catch {
                XCTFail("La suppression de l'utilisateur a échoué : \(error)")
            }
        }
    }
    
    
    
    
    func test_AuthentificationModelView_SignUpWithEmail_UserIsLoggedIn() {
        let expectation = XCTestExpectation(description: "Création de l'utilisateur")

        Task {
            do {
                let result = try await authentificationService!.createUser(email: testUserEmail, password: testUserPassword)
                try authentificationService!.signOut()
                // Effectuez ici des assertions pour vérifier si le résultat est correct
                XCTAssertNotNil(result.email)
                XCTAssertEqual(result.email, testUserEmail, "L'email n'est pas identique")
                XCTAssertNotNil(result.uid)
                
            } catch {
                XCTFail("La création de l'utilisateur a échoué : \(error)")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5) // Réglez le timeout en fonction de vos besoins
    }

    
    func test_AuthentificationModelView_SignInWithEmail_UserIsLoggedIn() {
        
    }

}
