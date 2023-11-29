//
//  PDFKitView.swift
//  MVP
//
//  Created by Guillaume Genest on 18/10/2023.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL // new variable to get the URL of the document
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
        DispatchQueue.global(qos: .background).async {
            if let document = PDFDocument(url: self.url) {
                DispatchQueue.main.async {
                    pdfView.document = document
                    pdfView.autoScales = true
                }
            }
        }
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // we will leave this empty as we don't need to update the PDF
    }
}
