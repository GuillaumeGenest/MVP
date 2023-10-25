//
//  QRcodeScan.swift
//  MVP
//
//  Created by Guillaume Genest on 23/10/2023.
//

import Foundation
import UIKit
import SwiftUI
import AVKit


class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate, CommunicationProtocol {
    
    
    @Published var data: String = ""
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let Code = readableObject.stringValue else { return }
            self.data = Code
        }
    }
}
