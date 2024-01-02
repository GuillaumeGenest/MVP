//
//  CommunicationView.swift
//  MVP
//
//  Created by Guillaume Genest on 08/11/2023.
//

import SwiftUI

struct CommunicationView: View {
    @StateObject var viewModel = NewTicketViewModel()
//    @Binding var tabBar: Int
    
    @Environment(\.dismiss) private var dismiss
    
    @State var SaveNewTicket: Bool = false
    @State var showPDF: Bool = false
    
    
    @State var urlPDF: String = ""
    @State var date: Date = Date()
    @State var BusinessId: String = ""
    @State var amount: Double = 0.0
    
    enum ModeCommunication {
        case nfc
        case QrCode
        case TakePhoto
    }
    
    @State private var currentMode : ModeCommunication = .nfc
    
    var body: some View {
        VStack{
            if !viewModel.urlPDFTicket.isEmpty, let pdfUrl = URL(string: viewModel.urlPDFTicket)  {
                VStack{
                    Text("Création d'un ticket")
                        .padding(.top, 15)
                    NewTicket(date: $date, BusinessId: $BusinessId, amount: $amount).padding(.horizontal, 10)
                        .padding(.top, 20)
                    VStack {
                        Button {
                            self.showPDF.toggle()
                        } label: {
                            HStack {
                                Text("Visualiser mon ticket ")
                                Spacer()
                                Image(systemName: self.showPDF ? "chevron.up" : "chevron.down")
                            }
                            .foregroundColor(Color.white)
                            .frame(height: 50)
                            .padding(.horizontal, 16)
                            .cornerRadius(10)
                        }
                            if self.showPDF {
                                PDFKitView(url: pdfUrl)
                                    .cornerRadius(15)
                                    .transition(.move(edge: .bottom))
                                    .animation(.easeInOut(duration: 0.4))
                            }
                       
                    }
                    .background(Color.bleu_empire.opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal, 10)
                    Spacer()
                    
                }.overlay( Button {
                    Task{
                        let NewTicket = Ticket(date: self.date, urlPDF: pdfUrl, value: amount, BusinessId: self.BusinessId)
                        try await viewModel.addTickets(ticket: NewTicket)
                    }
                } label: {
                    Text("Valider")
                        .foregroundColor(Color.white)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.bleu_empire)
                        .cornerRadius(10)
                }.padding()
                .padding(.top, 20),alignment: .bottom)
            } else {
                if currentMode == .nfc {
                    ScanNFCView(vm: viewModel)
                }
                if currentMode == .QrCode {
                    ScanQRcodeView(vm: viewModel)
                }
                if currentMode == .TakePhoto{
                    ScanTicketView(vm: viewModel)
                }
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
        .banner(isPresented: $viewModel.isSuccess){
                    dismiss()
                 }
                
                   
                .overlay(
                    HStack{ HeaderButton(action: {
                        dismiss()
                    }, nameIcon: "chevron.left")
                        Spacer()
                        Group {
                            if !viewModel.isSuccess || viewModel.inProcess == false {
                                Menu {
                                    Button(action: {currentMode = .nfc},
                                           label: {
                                        Label("NFC", systemImage: "configurationArray.NameIcon")
                                    })
                                    Button(action: {currentMode = .QrCode},
                                           label: {
                                        Label("QR-Code", systemImage: "qrcode")
                                    })
                                    Button(action: {currentMode = .TakePhoto},
                                           label: {
                                        Label("Prendre en Photo", systemImage: "camera.viewfinder")
                                    })
                                } label: {
                                    Image(systemName: "gear")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .font(.title2)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.bleu_empire)
                                        .cornerRadius(10)
                                        .shadow(radius: 4)
                                }
                            }
                            else {
                                
                            }
                        }
                    }
                    
                .padding(.all,15),alignment: .top)
        
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}
