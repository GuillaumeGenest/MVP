//
//  NFCReader.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import CoreNFC


class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate, CommunicationProtocol {
    var NFCSession : NFCNDEFReaderSession?
    @Published var data: String = ""
    
    
    func scan () {
        self.NFCSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.NFCSession?.alertMessage = "Hold your iPhone near the item to learn more about it."
        self.NFCSession?.begin()
    }


    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard
            let ndefMessage = messages.first,
            let record = ndefMessage.records.first,
            (record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown),
            let payloadText = String(data: record.payload, encoding: .utf8)
        else {
            return 
        }
        self.data = payloadText
        self.NFCSession?.invalidate()

    }
}
