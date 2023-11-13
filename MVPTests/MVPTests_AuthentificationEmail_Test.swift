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
    
    var authentificationService : AuthentificationService!
    var vm: AuthentificationModelView!
    private var testUserEmail: String = "unittest@example.com"
    private var testUserPassword: String = "password"
    
    @MainActor override func setUpWithError() throws {
        super.setUp()
        authentificationService = AuthentificationService()
        vm = AuthentificationModelView()
    }

    override func tearDownWithError() throws {
        authentificationService = nil
        vm = nil 
        super.tearDown()
    }
    
    func test_AuthentificationModelView_signUpWithEmail_InvalidEmail_ReturnInvalidFormatEmailError() {
        // Variables de test
        let invalidEmail = "invalid-email"
        let invalidConfirmationEmail = "invalid-email"
        
        guard let vm = vm else {
            XCTFail("AuthentificationModelView non initialisée correctement.")
            return
        }
        
        XCTAssertThrowsError(try vm.isValidEmail(invalidEmail, confirmationEmail: invalidConfirmationEmail)) { error in
            XCTAssertEqual(error as? AuthentificationError, AuthentificationError.invalidFormatEmail, "Erreur spécifique attendue : AuthentificationError.invalidFormatEmail")
        }
    }

    
    func test_AuthentificationModelView_signUpWithEmail_ValidEmail_ReturnValidFormatEmail() {
        // Variables de test
        let validEmail = "test@example.com"
        let validConfirmationEmail = "test@example.com"
        
        Task {
            do {
                try vm!.isValidEmail(validEmail, confirmationEmail: validConfirmationEmail)
            } catch {
                XCTFail("La validation d'e-mail a généré une erreur inattendue : \(error)")
            }
        }
    }
    
    func test_AuthentificationModelView_signUpWithEmail_NotMatchConfirmationEmail_emailsDoNotMatch() {
        // Variables de test
        let validEmail = "test@example.com"
        let ConfirmationEmailNoMatch = "test2@example.com"
        
        guard let vm = vm else {
            XCTFail("AuthentificationModelView non initialisée correctement.")
            return
        }
        
        XCTAssertThrowsError(try vm.isValidEmail(validEmail, confirmationEmail: ConfirmationEmailNoMatch)) { error in
            XCTAssertEqual(error as? AuthentificationError, AuthentificationError.emailsDoNotMatch, "Erreur spécifique attendue : AuthentificationError.invalidFormatEmail")
        }
    }
    

    

    
    
    func test_AuthentificationModelView_SignUpWithEmail_UserIsLoggedIn() {
        
        guard let authentificationService = authentificationService else {
            XCTFail("AuthentificationService non initialisée correctement.")
            return
        }
        
        
        
        Task {
            do {
                let result = try await authentificationService.createUser(email: testUserEmail, password: testUserPassword)
                
                // Effectuez ici des assertions pour vérifier si la création de l'utilisateur est réussie
                XCTAssertNotNil(result.email)
                XCTAssertEqual(result.email, testUserEmail, "L'email n'est pas identique")
                XCTAssertNotNil(result.uid)
                
                // Supprimez le compte utilisateur après les assertions
                try await authentificationService.delete()
            } catch {
                XCTFail("La création de l'utilisateur a échoué : \(error)")
            }
        }
    }



    
    func test_AuthentificationModelView_SignInWithEmail_UserIsLoggedIn() {
        
    }

}
