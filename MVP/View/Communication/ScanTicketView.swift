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
    @ObservedObject var vm: ViewModel

    
    @State var date = Date()
    
    var body: some View {
        VStack {
        ZStack {
            Color.black
        
                GeometryReader { proxy in
                    let size = proxy.size
                    ZStack {
                        CameraPreview(camera: camera, frameSize: size)
                            .ignoresSafeArea(.all, edges: .all)
                        VStack {
                            Spacer()
                            HStack {
                                if camera.previewphoto {
                                    Button {
                                        AddTicket()
                                    } label: {
                                        Text("Sauvegarder")
                                            .foregroundColor(.black)
                                            .fontWeight(.semibold)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 20)
                                            .background(Color.white)
                                            .clipShape(Capsule())
                                    }
                                } else {
                                    Button {
                                        camera.takePhoto()
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 3)
                                                .frame(width: 72, height: 72)
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 60, height: 60)
                                        }
                                    }
                                }
                            }
                        }.padding(.bottom, 30)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(isPresented: $vm.DisplayErrorMessage) {
            return Alert(title: Text("IMTY0"), message: Text(vm.StatusMessage)
                .foregroundColor(.red),
                         dismissButton: .cancel(Text("Annuler"))
            )
        }
       
        .overlay(
            Group {
                if camera.previewphoto {
                    HeaderButton(action: {
                        camera.retakePhoto()
                    }, nameIcon: "xmark")
                }
            }.padding(.all,15), alignment: .topLeading)
        }.overlay(LoadingView(show: $vm.isLoading))
        .onAppear(perform: camera.checkCameraPermission)
    }
    
    
    private func AddTicket() {
        Task {
            do {
                vm.isLoading = true
                guard !camera.dataImage.isEmpty else {
                    vm.isLoading = false
                    vm.StatusMessage = camera.message
                    vm.DisplayErrorMessage = true
                    return
                }
                let id = UUID()
                let regeneratedPDFData = try camera.regeneratePDFData(from: camera.dataImage)
                let url = try await vm.saveDataToPDF(TicketId: id.uuidString, ticketvalue: regeneratedPDFData)
                let NewTicket = Ticket(id: id, date: self.date, urlPDF: URL(string: url)!)
                try await vm.addTickets(ticket: NewTicket)

                camera.retakePhoto()
                vm.isLoading = false
            } catch {
                vm.isLoading = false
                await vm.setError(error)
            }
        }
    }
}



struct ScanTicketView_Previews: PreviewProvider {
    static let vm = ViewModel()
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
