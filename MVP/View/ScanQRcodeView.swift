//
//  ScanQRcodeView.swift
//  MVP
//
//  Created by Guillaume Genest on 20/10/2023.
//

import SwiftUI

struct ScanQRcodeView: View {
    var body: some View {
        VStack {
            VStack{
                
                Text("Place the QR code inside the area")
                    .font(.title3)
                    .padding(.top, 20)
                Text("Scanning will start automatically")
                    .font(.callout)
                Text("Hello World")
                           .frame(width: 275, height: 275)
                           .overlay(
                               Rectangle()
                                   .stroke(Color.yellow, style: StrokeStyle(lineWidth: 5.0,lineCap: .round, lineJoin: .bevel, dash: [60, 215], dashPhase: 29))
                           )
                GeometryReader {
                    let size = $0.size
                    ZStack {
                        ForEach(0...4, id: \.self){ index in
                            let rotation = Double(index) * 90
                            RoundedRectangle(cornerRadius: 2, style: .circular)
                                .trim(from: 0.61, to: 0.64)
                                .stroke(Color.bleu_empire, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.init(degrees: rotation))
                        }
                    }.frame(width: size.width, height: size.width)
                        .padding()
                }
                
                
                
                
               
            }.onAppear{
            }
        }
    }
}

struct ScanQRcodeView_Previews: PreviewProvider {
    static var previews: some View {
        ScanQRcodeView()
    }
}
