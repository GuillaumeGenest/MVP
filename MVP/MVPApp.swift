//
//  MVPApp.swift
//  MVP
//
//  Created by Guillaume Genest on 13/10/2023.
//

import SwiftUI
import Firebase

@main
struct MVPApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
