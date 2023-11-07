//
//  MVPTest_NFC_Test.swift
//  MVPTests
//
//  Created by Guillaume Genest on 03/11/2023.
//

import XCTest
import CoreNFC
@testable import MVP

final class MVPTest_NFC_Test: XCTestCase {
    var nfcReader: NFCReader!
        
        override func setUp() {
            super.setUp()
            nfcReader = NFCReader()
        }

        override func tearDown() {
            nfcReader = nil
            super.tearDown()
        }

        func testScan() {
            XCTAssertNil(nfcReader.NFCSession, "NFCSession should be nil initially")
            nfcReader.scan()
            XCTAssertNotNil(nfcReader.NFCSession, "NFCSession should not be nil after scanning")
        }
        
    func testDidDetectNDEFs() {
    
        let urlString: String = "www.apple.com"
        guard let url = URL(string: urlString) else {
            XCTFail("Failed to create URL from string")
            return
        }

        guard let uriRecord = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            XCTFail("Failed to create URI record")
            return
        }

        let ndefMessage = NFCNDEFMessage(records: [uriRecord])
        let nfcMessages = [ndefMessage]

        nfcReader.scan()
        if let nfcSession = nfcReader.NFCSession {
            nfcReader.readerSession(nfcSession, didDetectNDEFs: nfcMessages)
        } else {
            XCTFail("NFCSession is nil")
        }
        let cleanedURLString = nfcReader.data.replacingOccurrences(of: "\0", with: "")
        XCTAssertEqual(cleanedURLString, urlString, "NFC data should be the URL")
    }

    func testDidDetectNDEFsEmptyMessage() {
        let message = NFCNDEFMessage(records: [])
        nfcReader.scan()
        if let nfcSession = nfcReader.NFCSession {
            nfcReader.readerSession(nfcSession, didDetectNDEFs: [message])
            XCTAssertEqual(nfcReader.data, "", "NFC data should be empty")
        } else {
            XCTFail("NFCSession is nil")
        }
    }

    func testDidDetectNDEFsInvalidMessage() {
        let ndefMessage = NFCNDEFMessage(records: [])
        let nfcMessages = [ndefMessage]

        nfcReader.scan()
        if let nfcSession = nfcReader.NFCSession {
                nfcReader.readerSession(nfcSession, didDetectNDEFs: nfcMessages)
        } else {
            XCTFail("NFCSession is nil")
        }
        let cleanedURLString = nfcReader.data.replacingOccurrences(of: "\0", with: "")
        XCTAssertEqual(cleanedURLString, "", "NFC data should be the URL")
    }

    func testDidInvalidateWithError() {
        let error = NSError(domain: "TestError", code: 1, userInfo: nil)
        nfcReader.scan()
        if let nfcSession = nfcReader.NFCSession {
            nfcReader.readerSession(nfcSession, didInvalidateWithError: error)
        } else {
            XCTFail("NFCSession is nil")
        }
    }


}
