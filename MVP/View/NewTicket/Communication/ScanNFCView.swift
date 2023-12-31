//
//  ScanNFCView.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI

struct ScanNFCView: View {
    @StateObject var nfcReader = NFCReader()
    @ObservedObject var vm : NewTicketViewModel
    
    @State var date = Date()

    
    
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            if !nfcReader.data.isEmpty, let pdfUrl = URL(string: nfcReader.data) {
                VStack{
                    PDFKitView(url: pdfUrl)
                }.onAppear{
                    //download Item
                }.overlay(
                    HeaderButton(action: { nfcReader.data = ""
                        dismiss()
                    }, nameIcon: "xmark")
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    , alignment: .topLeading)
                .overlay(RegisterButton(title: "Valider le PDF", action: {
                    vm.urlPDFTicket = nfcReader.data
                }, color: Color.bleu_empire).padding(.horizontal, 20)
        .padding(.bottom, 10)
    , alignment: .bottom)
            }
            else {
                VStack{
                    Button {
                        nfcReader.scan()
                    } label: {
                        VStack{
                            Text("Tap pour activer \n le nfc")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.bleu_empire)
                                .font(.system(size: 25, weight: .semibold))
                            
                            VStack{
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.bleu_empire, lineWidth: 4)
                                        .frame(width: 100, height: 100)
                                    VStack{
                                        Text("NFC")
                                            .font(.system(size: 35, weight: .semibold))
                                        Image(systemName: "dot.radiowaves.up.forward")
                                            .foregroundColor(Color.bleu_empire)
                                            .font(.system(size: 35, weight: .semibold))
                                        
                                    }
                                    .foregroundColor(Color.bleu_empire)
                                    .font(.system(size: 35, weight: .semibold))
                                }.shadow(radius: 10)
                                    .padding(.top, 10)
                            }
                        }
                    }
                }.onAppear{
                    nfcReader.scan()
                }
            }
    }
}

struct ScanNFCView_Previews: PreviewProvider {
    static let vm = NewTicketViewModel()
    static var previews: some View {
        ScanNFCView(vm: vm)
    }
}
