//
//  CameraModelView.swift
//  MVP
//
//  Created by Guillaume Genest on 15/11/2023.
//

import Foundation
import SwiftUI
import UIKit
import AVKit
import AVFoundation
import PDFKit


class CameraModelView: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var cameraPermission: Permission = .Denied
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var previewphoto: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
    @Published var dataImage = Data()
    
    
    

     var sessionQueue: DispatchQueue!
    
    override init() {
        super.init()
        initialize()
    }
    
    private func initialize() {
        sessionQueue = DispatchQueue(label: "session queue")
    }
    
    
//    private func checkAuthorization() async -> Bool {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            print("Camera access authorized.")
//            return true
//        case .notDetermined:
//            print("Camera access not determined.")
//            sessionQueue.suspend()
//            let status = await AVCaptureDevice.requestAccess(for: .video)
//            sessionQueue.resume()
//            return status
//        case .denied:
//            print("Camera access denied.")
//            return false
//        case .restricted:
//            print("Camera library access restricted.")
//            return false
//        @unknown default:
//            return false
//        }
//    }
//
//
//
//    func start() async {
//        let authorized = await checkAuthorization()
//        guard authorized else {
//            print("Camera access was not authorized.")
//            return
//        }
//
//
//        sessionQueue.async { [self] in
//            self.configureCaptureSession { success in
//                guard success else { return }
//                self.session.startRunning()
//            }
//        }
//    }
//
//
//    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
//
//        var success = false
//
//        self.session.beginConfiguration()
//
//        defer {
//            self.session.commitConfiguration()
//            completionHandler(success)
//        }
//        guard let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
//            print("Error: No camera device found.")
//            return
//        }
//
//        do {
//               let input = try AVCaptureDeviceInput(device: device)
//               if session.canAddInput(input) {
//                   session.addInput(input)
//               } else {
//                   print("Error: Cannot add input.")
//                   return
//               }
//           } catch {
//               print("Error setting up camera input: \(error.localizedDescription)")
//               return
//           }
//           if session.canAddOutput(output) {
//               session.addOutput(output)
//           } else {
//               print("Error: Cannot add output.")
//               return
//           }
//
//        session.beginConfiguration()
//        session.addOutput(output)
//        session.commitConfiguration()
//
//
////        isCaptureSessionConfigured = true
//
//        success = true
//    }
    
    
    
    

    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    setupCamera()
                } else {
                    cameraPermission = .Denied
                    handlePermissionError("Please provide camera access in settings.")
                }
            case .denied, .restricted:
                cameraPermission = .Denied
                handlePermissionError("Please provide camera access in settings.")
            default:
                break
            }
        }
    }

    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) else {
                print("Error: No camera device found.")
                return
            }

            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(output) else {
                print("Error: Cannot add input or output.")
                return
            }

            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(output)
            session.commitConfiguration()

            sessionQueue.async {
                self.session.startRunning()
            }

        } catch {
            print("Error setting up the camera: \(error.localizedDescription)")
        }
    }

    
//    func take() {
//        guard let photoOutput = self.photoOutput else { return }
//        sessionQueue.async {
//            let photoSettings = AVCapturePhotoSettings()
//            photoOutput.capturePhoto(with: photoSettings, delegate: self)
//        }
//    }
    

    func takePhoto() {
        sessionQueue.async{
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
        }
    }

    func retakePhoto() {
        sessionQueue.async{
            self.session.startRunning()
            self.previewphoto.toggle()
        }
    }

    func handlePermissionError(_ errorMessage: String) {
        self.message = errorMessage
        showAlert.toggle()
    }


    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
               
        self.previewphoto.toggle()
        self.session.stopRunning()
        
                if error != nil {
                    self.message = "error.localizedDescription"
                    return
                }

                guard let imageData = photo.fileDataRepresentation() else {
                    self.message = "Erreur : les données de l'image sont vides."
                    return
                }

                if imageData.isEmpty {
                    self.message = "imageData est vide (\(imageData.count) octets)"
                    return
                }
                self.dataImage = imageData
                self.message = "la valeur de dataImage \(dataImage.count)"
                
    }
    
    
    private func handlePhotoCaptureError(_ errorMessage: String) {
        self.message = errorMessage
    }
}
