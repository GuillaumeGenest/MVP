//
//  ContentView.swift
//  MVP
//
//  Created by Guillaume Genest on 13/10/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appsettings: AppSettings
    @StateObject var viewModel = ViewModel()
    @State var ScanNFCTicket : Bool = false
    @State var ScanQRcodeTicket : Bool = false
    @State private var isRotated = false
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    Text("Liste de mes tickets!")
                    
                }
                if viewModel.tickets.isEmpty {
                    Text("Il y a aucun ticket")
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(viewModel.tickets){content in
                            TicketCell(ticket: content)
                        }
                    }.refreshable {
                        Task{
                            await viewModel.fetchData()
                        }
                    }
                }
            }.task{
                await viewModel.fetchData()
            }
            .overlay(
                VStack {
                    if isRotated == true {
                        
                        CommunicationButtonView(iconName: "dot.radiowaves.up.forward", action: {ScanNFCTicket.toggle()})
                        CommunicationButtonView(iconName: "qrcode.viewfinder", action: {ScanQRcodeTicket.toggle()})
                
                    }
                    Button {
                        withAnimation {
                                        self.isRotated.toggle()
                                    }
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .rotationEffect(.degrees(isRotated ? 45 : 0))
                            .font(.title2)
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(Color.bleu_empire)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }

                }
                
                
                
                .padding(.all,15),alignment: .bottomTrailing)
            .navigationDestination(isPresented: $ScanQRcodeTicket) {
                ScanQRcodeView(vm: viewModel
                )
            }
            .navigationDestination(isPresented: $ScanNFCTicket) {
                    ScanNFCView(vm: viewModel)
                }
                .navigationTitle("MVP")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppSettings())
    }
}
