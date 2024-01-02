//
//  ContentView.swift
//  MVP
//
//  Created by Guillaume Genest on 13/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var scanTicket: Bool = false
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    Text("Liste de mes tickets!")
                    
                }
//                List(viewModel.ticketInfo.keys.sorted(), id: \.self) { ticketID in
//                    if let ticketResponse = viewModel.ticketInfo[ticketID], let businessResponse = viewModel.businessInfo[ticketID]{
//                               Text("Date: \(ticketResponse.date)")
//                               Text("URL PDF: \(ticketResponse.urlPDF)")
//                        Text("Value: \(ticketResponse.value)")
//                        Text("Business: \(businessResponse.name)")
//                               // Ajoutez d'autres Text pour afficher d'autres propriétés si nécessaire
//                           }
//                       }
//                if viewModel.tickets.isEmpty {
//                    Text("Il y a aucun ticket")
//                    Spacer()
//                } else {
                    ScrollView {
                        ForEach(viewModel.ticketInfo.keys.sorted(), id: \.self) { ticketID in
                if let ticketResponse = viewModel.ticketInfo[ticketID], let businessResponse = viewModel.businessInfo[ticketID]{
                    NavigationLink(
                        destination: TicketView(viewmodel: viewModel, ticket: ticketResponse, business: businessResponse),
                        label: {
                            TicketCell(ticket: ticketResponse, business: businessResponse)
                                .environmentObject(viewModel)
                        })
                        }
                    }.refreshable {
                        Task{
                            do {
                               try await viewModel.fetchTest()
                            } catch {
                                await viewModel.setError(error)
                            }
                        }
                    }
                }
            }.task{
                do {
                   try await viewModel.fetchTest()
                } catch {
                    await viewModel.setError(error)
                }
            }.alert(isPresented: $viewModel.DisplayErrorMessage) {
                return Alert(title: Text("IMTY0"), message: Text(viewModel.StatusMessage)
                    .foregroundColor(.red),
                             dismissButton: .cancel(Text("Annuler"))
                )
            }
            .overlay( PlusButtonView(action: {scanTicket.toggle()}).padding(.all,35),alignment: .bottomTrailing)
            .navigationDestination(isPresented: $scanTicket) {
                CommunicationView()
                    .navigationBarBackButtonHidden(true)
            }
            .navigationTitle("IMTY0")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
