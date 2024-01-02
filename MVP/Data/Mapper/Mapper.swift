//
//  Mapper.swift
//  MVP
//
//  Created by Guillaume Genest on 22/12/2023.
//

import Foundation



class Mapper {
    static func mapResponseToTicketAndBusiness(_ response: TicketResponse) -> (ticket: Ticket, business: Business) {
        let ticket = Ticket(date: response.tickets.date, urlPDF: URL(string: response.tickets.urlPDF)!, value: response.tickets.value, BusinessId: response.business.id)

        let business = Business(name: response.business.name, logo: response.business.logo, color: response.business.color)
        return (ticket, business)
    }


    static func mapResponseToTicketAndBusinesswithkey(_ key: String, response: TicketResponse) -> (key: String, ticket: Ticket, business: Business) {
        let ticket = Ticket(date: response.tickets.date, urlPDF: URL(string: response.tickets.urlPDF)!, value: response.tickets.value, BusinessId: response.business.id)

        let business = Business(name: response.business.name, logo: response.business.logo, color: response.business.color)
        return (key, ticket, business)
    }
}
