//
//  ContentView.swift
//  MVP
//
//  Created by Guillaume Genest on 13/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
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
                                .environmentObject(viewModel)
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
                .navigationTitle("IMTY0")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
