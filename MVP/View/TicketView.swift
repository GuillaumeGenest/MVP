//
//  TicketView.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI
import PDFKit


struct TicketView: View {
    
    @ObservedObject var viewmodel: ViewModel

    @ObservedObject var ticket: Ticket
    @Environment(\.dismiss) private var dismiss
    
    var pdf: PDFDocument {
        return PDFDocument(url: ticket.urlPDF)!
    }
    
    var body: some View {
        NavigationStack{
            PDFKitView(url: ticket.urlPDF)
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("Mon ticket", displayMode: .inline)
                .navigationBarItems(
                                   leading: HeaderButton(action: {
                                       dismiss()
                                   }, nameIcon: "arrow.left"),
                                   trailing: Menu {
                                       Button {
                                           //
                                       } label: {
                                           Label("Modifier", systemImage: "pencil")
                                       }
                                       ShareLink(item: pdf, preview: SharePreview("\(ticket.id).pdf")){
                                         Label("Partager", systemImage: "square.and.arrow.up")
                                       }
                                       
                                       Button {
                                           Task {
                                               try await  viewmodel.deleteTickets(ticket: self.ticket)
                                           }
                                       } label: {
                                           Label("Supprimer", systemImage: "trash")
                                               .foregroundColor(Color.red)
                                       }
                                   } label: {
                                       Image(systemName: "ellipsis.circle")
                                           .resizable()
                                           .aspectRatio(contentMode: .fit)
                                           .frame(width: 20, height: 20)
                                           .font(.headline)
                                           .padding(8)
                                           .foregroundColor(.primary)
                                           .background(.thickMaterial)
                                           .cornerRadius(10)
                                           .shadow(radius: 4)
                                   }
                               )
        }
        
    }
}

struct TicketView_Previews: PreviewProvider {
    static let vm = ViewModel()
    static var previews: some View {
        TicketView(viewmodel: vm, ticket: previewTicket[0])
    }
}
