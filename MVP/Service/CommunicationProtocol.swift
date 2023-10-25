//
//  CommunicationProtocol.swift
//  MVP
//
//  Created by Guillaume Genest on 25/10/2023.
//

import Foundation



protocol CommunicationProtocol: ObservableObject {
     var data: String { get set }
}
