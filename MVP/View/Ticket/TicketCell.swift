//
//  TicketCell.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI

struct TicketCell: View {
    @ObservedObject var ticket: Ticket
    var business: Business
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
                ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.cellcolor)
                            .shadow(color: Color(Color.RGBColorSpace.sRGB, white: 0, opacity: 0.2), radius: 4)
                        
                        HStack {
                            if let logoURL = URL(string: business.logo) {
                                AsyncImage(url: logoURL) { phase in
                                    if let image = phase.image {
                                        image
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 70, height: 70)
                                            .clipped()
                                            .cornerRadius(15)
                                    }
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(business.name)
                                        .tracking(0.15)
                                        .font(.headline)
                                        .font(Font.custom("Inter-ExtraBold", size: 14))
                                        .lineLimit(0)
                                    
                                    Text(ticket.date.FormattedDate(format: "dd.MM.yy"))
                                        .font(.caption)
                                }
                                Spacer()
                                Text(ticket.value.formattedCurrencyText)
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
                    .cornerRadius(16)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.horizontal, 8)
    }
}

struct TicketCell_Previews: PreviewProvider {
    static var previews: some View {
        TicketCell(ticket: previewTicket[0], business: mockedbussiness[0])
    }
}
