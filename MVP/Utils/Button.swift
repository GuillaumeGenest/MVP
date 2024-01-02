//
//  Button.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import Foundation
import SwiftUI
struct HeaderButton: View {
    var action: () -> Void
    var nameIcon: String
    var body: some View{
        Button(action: action,label: {
            Image(systemName: nameIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .font(.headline)
                .padding(8)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
        })
    }
}

struct RegisterButton: View {
    var title : String
    var action: () -> Void
    let color: Color
    var body: some View{
        Button(action: action, label: {
            ZStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(35.0)
            }.shadow(radius: 10)
            })
    }
}
struct CommunicationButtonView: View {
    let iconName: String
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .font(.title2)
                .padding(10)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
            
        })
    }
}



struct PlusButtonView: View {
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.bleu_empire)
                .frame(width: 50, height: 50)
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
        }.shadow(radius: 10)
        
        })
    }
}

struct button_log: View {
    let name : String
    let action: () -> Void
    let colorbackground: Color
    let colorforeground: Color
    var body: some View {
        Button(action: action, label: {
        ZStack {
        Text("\(name)")
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundColor(colorforeground)
            .padding()
            .background(colorbackground)
            .cornerRadius(35.0)
        }.shadow(radius: 10)
        })
    }
}
