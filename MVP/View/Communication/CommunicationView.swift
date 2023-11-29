//
//  CommunicationView.swift
//  MVP
//
//  Created by Guillaume Genest on 08/11/2023.
//

import SwiftUI

struct CommunicationView: View {
    @StateObject var viewModel = ViewModel()
    
    
    enum ModeCommunication {
        case nfc
        case QrCode
        case TakePhoto
    }
    
    @State private var currentMode : ModeCommunication = .nfc
    
    var body: some View {
        VStack{
            if currentMode == .nfc {
                ScanNFCView(vm: viewModel)
            }
            if currentMode == .QrCode {
                ScanQRcodeView(vm: viewModel)
            }
            if currentMode == .TakePhoto{
                ScanTicketView(vm: viewModel)
            }
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
        .overlay(
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
                    .frame(width: 25, height: 25)
                    .font(.title2)
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.bleu_empire)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        .padding(.all,15),alignment: .topTrailing)
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}
