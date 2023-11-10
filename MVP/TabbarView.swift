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
        TabView {
            NavigationStack {
                ContentView()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Tickets")
            }
            
            NavigationStack {
                CommunicationView()
            }
            .tabItem {
                Image(systemName: "plus")
                Text("Communication")
            }
            
            NavigationStack {
                Settings(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
        }.background(Color.cellcolor)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(showSignInView: .constant(false))
    }
}


