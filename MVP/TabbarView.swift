//
//  TabbarView.swift
//  MVP
//
//  Created by Guillaume Genest on 07/11/2023.
//

import SwiftUI

struct TabbarView: View {
    @Binding var showSignInView: Bool
    
    
    @State private var selection = 0
    var body: some View {
        VStack {
            TabView(selection: $selection){
                    ContentView()
                    .tag(0)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Tickets")
                }
                
                
                CommunicationView(tabBar: $selection)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "plus")
                        Text("Communication")
                    }
                
                    Settings(showSignInView: $showSignInView)
                    .tag(2)
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


