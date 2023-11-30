//
//  MVPTest_Camera_Test.swift
//  MVPTests
//
//  Created by Guillaume Genest on 29/11/2023.
//

import XCTest
@testable import MVP

final class MVPTest_Camera_Test: XCTestCase {

    var camera: CameraModelView!
    
    
    override func setUp() {
        super.setUp()
        camera = CameraModelView()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() {
        XCTAssertEqual(camera.cameraPermission, .Denied)
        XCTAssertNotNil(camera.dataImage)
        XCTAssertNotNil(camera.sessionQueue)
        XCTAssertEqual(camera.sessionQueue.label, "session queue")
    }
    
    
    func testCheckCameraPermission() {
            
            // Simuler une autorisation refusée
        camera.cameraPermission = .Denied
        camera.checkCameraPermission()
        XCTAssertTrue(camera.showAlert)
        XCTAssertEqual(camera.message, "Please provide camera access in settings.")

            // Simuler une autorisation non déterminée
        camera.cameraPermission = .NotDetermined
        camera.checkCameraPermission()
        XCTAssertTrue(camera.showAlert)
        XCTAssertEqual(camera.message, "Please provide camera access in settings.")
        
        
        
        camera.cameraPermission = .Approved
        camera.checkCameraPermission()
            XCTAssertFalse(camera.showAlert)
            XCTAssertEqual(camera.message, "")
        }

}
