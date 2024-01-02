//
//  ScanTicketView.swift
//  MVP
//
//  Created by Guillaume Genest on 15/11/2023.
//

import SwiftUI
import AVKit
import AVFoundation

struct ScanTicketView: View {
    @StateObject var camera = CameraModelView()
    @ObservedObject var vm: NewTicketViewModel

    @State private var capturedImage: UIImage?
    @State var date = Date()
    
    var body: some View {
        VStack {
            if let capturedImage = capturedImage {
                ZStack {
                    Color.black
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                AddTicket()
                            } label: {
                                Text("Valider le PDF")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.bleu_empire)
                                    .clipShape(Capsule())
                            }.padding(.bottom, 20)
                        }
                    }
                }
            } else {
                DocumentScannerView(scannedImage: $capturedImage)
            }
        }.overlay(
            Group {
                if capturedImage != nil {
                    HeaderButton(action: {
                        capturedImage = nil
                    }, nameIcon: "xmark")
                }
            }.padding(.all,15), alignment: .topLeading)
        .overlay(LoadingView(show: $vm.isLoading))
    }
    
    private func AddTicket() {
            Task {
                do {
//                    vm.isLoading = true
////                    guard !camera.dataImage.isEmpty else {
////                        vm.isLoading = false
////                        vm.StatusMessage = camera.message
////                        vm.DisplayErrorMessage = true
////                        return
////                    }
                    let id = UUID()
                    let regeneratedPDFData = try vm.regeneratePDFData(from: capturedImage!)
                    let url = try await vm.saveDataToPDF(TicketId: id.uuidString, ticketvalue: regeneratedPDFData)
                    
                    vm.urlPDFTicket = url
//                    let NewTicket = Ticket(id: id, date: self.date, urlPDF: URL(string: url)!)
//                    try await vm.addTickets(ticket: NewTicket)
    
                    capturedImage = nil
                    vm.isLoading = false
                } catch {
                    vm.isLoading = false
                    await vm.setError(error)
                }
            }
        }
}



struct ScanTicketView_Previews: PreviewProvider {
    static let vm = NewTicketViewModel()
    static var previews: some View {
        ScanTicketView(vm: vm)
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModelView
    
    var frameSize: CGSize
    
    
    func makeUIView(context: Context) -> some UIView {
          let view = UIView()
          view.backgroundColor = .clear
          camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
          camera.preview.videoGravity = .resizeAspectFill
          camera.preview.frame = CGRect(origin: .zero, size: frameSize)
          view.layer.addSublayer(camera.preview)
          camera.session.startRunning()
          return view
      }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }   
}

