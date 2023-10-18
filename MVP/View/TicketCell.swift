//
//  TicketCell.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI

struct TicketCell: View {
    @ObservedObject var ticket: Ticket
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        
        NavigationLink(
            destination:
                TicketView(ticket: ticket),
            label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16,
                                     style: .continuous)
                    .fill(Color.cellcolor)
                    .shadow(color: Color(Color.RGBColorSpace.sRGB,
                                         white: 0, opacity: 0.2) , radius: 4)
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(ticket.id.uuidString)
                                    .tracking(0.15)
                                    .font(.headline)
                                    .font(Font.custom("Inter-ExtraBold", size: 14))
                                    .lineLimit(0)
                            }
                            HStack{
                                Text(ticket.urlPDF.absoluteString)
                                    .font(.caption)
                                    .lineLimit(0)
                                Text(ticket.date.FormattedDate(format: "dd.MM.yy"))
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
                //.background(lightGreyColor)
                .cornerRadius(16)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.horizontal, 8)
            })
    }
    
}

struct TicketCell_Previews: PreviewProvider {
    static var previews: some View {
        TicketCell(ticket: previewTicket[0])
    }
}
