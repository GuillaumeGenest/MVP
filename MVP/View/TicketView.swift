//
//  TicketView.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI

struct TicketView: View {
    @ObservedObject var ticket: Ticket
    var body: some View {
        
            PDFKitView(url: ticket.urlPDF)
        
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        TicketView(ticket: previewTicket[0])
    }
}
