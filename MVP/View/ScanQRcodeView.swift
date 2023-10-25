//
//  ScanQRcodeView.swift
//  MVP
//
//  Created by Guillaume Genest on 20/10/2023.
//

import SwiftUI
import AVKit
import AVFoundation

struct ScanQRcodeView: View {
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput : AVCaptureMetadataOutput = .init()
    @State private var cameraPermission: Permission = .Denied
    @StateObject private var qrDelelegate = QRScannerDelegate()
    @ObservedObject var vm : ViewModel
    @State var date = Date()
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    var body: some View {
    
            
            if !qrDelelegate.data.isEmpty, let pdfUrl = URL(string: qrDelelegate.data) {
                    VStack{
                        PDFKitView(url: pdfUrl)
                    }.overlay(
                        HeaderButton(action: { qrDelelegate.data = ""
                            dismiss()
                        }, nameIcon: "xmark")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        , alignment: .topLeading)
                    .overlay(RegisterButton(title: "Enregistrer", action: {
                        Task {
                            let NewTicket = Ticket(date: self.date, urlPDF: URL(string: qrDelelegate.data)!)
                            try await vm.addTickets(ticket: NewTicket)
                            dismiss()
                        }
                    }, color: Color.bleu_empire).padding(.horizontal, 20)
            .padding(.bottom, 10)
        , alignment: .bottom)
            } else {
                VStack{
                    
                    Text("Place the QR code inside the area")
                        .font(.title3)
                        .padding(.top, 20)
                    Text("Scanning will start automatically")
                        .font(.callout)
                    GeometryReader {
                        
                        let size = $0.size
                        CameraView(session: $session, frameSize: CGSize(width: size.width, height: size.width))
                            .overlay(
                                Rectangle()
                                    .stroke(Color.yellow, lineWidth: 2) 
                                    .frame(width: size.width/3, height: size.width/3)
                                    
                            
                            
                            )
                        
                    }
                }.onAppear(perform: checkCameraPermission)
                    .alert(errorMessage, isPresented: $showError){
                        if cameraPermission == .Denied {
                            Button("Settings"){
                                let settingsString = UIApplication.openSettingsURLString
                                if let settingsURL = URL(string: settingsString){
                                    openURL(settingsURL)
                                }
                            }
                            Button("cancel", role: .cancel){
                                
                            }
                        }
                    }
            
        }
    }
    
    
    func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera], mediaType: .video, position: .back).devices.first else {
                print("error")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                print("error input and output")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
                    
        }
        catch {
            presentError("Impossible de visualiser le QR code")
        }
    }
    
    
    func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .authorized:
                cameraPermission = .Approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    setupCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .Approved
                    setupCamera()
                } else {
                    cameraPermission = .Denied
                    presentError("Please provide settings")
                }
            case .denied, .restricted:
                cameraPermission = .Denied
                presentError("Please provide settings")
            default:
                break
            }
        }
    }
    
    
    
    func presentError(_ message: String){
        
    }
    
    
    
    
}

struct ScanQRcodeView_Previews: PreviewProvider {
    static let vm = ViewModel()
    static var previews: some View {
        ScanQRcodeView(vm: vm)
    }
}

struct CameraView : UIViewRepresentable {
    @Binding var session: AVCaptureSession
    var frameSize: CGSize

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Mettez à jour la vue si nécessaire.
    }
}


enum Permission: String {
    case NotDetermined = "Not Determined"
    case Approved = "Access Authorized"
    case Denied = "Access Denied"
}
