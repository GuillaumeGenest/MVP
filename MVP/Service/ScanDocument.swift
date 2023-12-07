//
//  ScanDocument.swift
//  MVP
//
//  Created by Guillaume Genest on 06/12/2023.
//

import Foundation
import VisionKit
import PDFKit
import SwiftUI


struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerView

        init(parent: DocumentScannerView) {
            self.parent = parent
        }
        

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let image = scan.imageOfPage(at: 0)
            parent.scannedImage = image
            controller.dismiss(animated: true, completion: nil)
            return
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            
            print("Document scanning failed with error: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
          return Coordinator(parent: self)
      }

      func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
          let documentCameraViewController = VNDocumentCameraViewController()
          
          documentCameraViewController.delegate = context.coordinator
          documentCameraViewController.view.frame = .infinite
          documentCameraViewController.modalPresentationStyle = .fullScreen
          return documentCameraViewController
      }

      func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
          // Si une image a été numérisée, affichez-la
          if let scannedImage = scannedImage {
              let imageView = UIImageView(image: scannedImage)
              imageView.contentMode = .scaleAspectFit
              uiViewController.view.addSubview(imageView)
          }
      }
}
