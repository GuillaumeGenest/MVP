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

struct NfcButtonView: View {
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.bleu_empire)
                .frame(width: 50, height: 50)
            Image(systemName: "dot.radiowaves.up.forward")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .semibold))
        }.shadow(radius: 10)
        
        })
    }
}
