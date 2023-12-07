//
//  SwiftUIView.swift
//  MVP
//
//  Created by Guillaume Genest on 30/11/2023.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        HStack{
            Label("Bravo: Vous avez ajouté un ticket 🥳", systemImage: "checkmark.circle")
        }.padding()
            .background(Color.green)
            .foregroundColor(Color.black)
            .cornerRadius(8)
            .padding(.horizontal, 4)
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}


struct BannerModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    
    
    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    if isPresented {
                        BannerView()
                            .transition(AnyTransition.move(edge: .top))
                            .onTapGesture {
                                withAnimation {
                                    self.isPresented = false
                                    onDismiss()
                                }
                            }
                            .onAppear(perform: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        self.isPresented = false
                                        onDismiss()
                                    }
                                }
                            })
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isPresented)
                .padding(.top, 20), alignment: .top)
    }
}


extension View {
    func banner(isPresented: Binding<Bool>, onDismiss: @escaping () -> Void) -> some View {
        self.modifier(BannerModifier(isPresented: isPresented, onDismiss: onDismiss))
    }
}
