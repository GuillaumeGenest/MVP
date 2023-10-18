//
//  NFCReader.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import CoreNFC


class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var NFCSession : NFCNDEFReaderSession?
    @Published var nfcData: String = ""
    
    
    func scan () {
        self.NFCSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.NFCSession?.alertMessage = "Hold your iPhone near the item to learn more about it."
        self.NFCSession?.begin()
    }


    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
           for message in messages {
               for record in message.records {
                   if let payload = String(data: record.payload, encoding: .utf8) {
                       self.nfcData = payload
                   }
               }
           }
       }
    
}
