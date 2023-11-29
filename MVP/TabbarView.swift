//
//  TabbarView.swift
//  MVP
//
//  Created by Guillaume Genest on 07/11/2023.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TabView {
                    ContentView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Tickets")
                }
                
                
                CommunicationView()
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Communication")
                    }
                
                    Settings(showSignInView: $showSignInView)
                
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            }.background(Color.black.opacity(0.3))
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(false))
    }
}


