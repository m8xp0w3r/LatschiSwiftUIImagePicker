//
//  ImagePicker.swift
//  LatschiSwiftUIImagePicker
//
//  Created by Nils Leistner on 15.04.22.
//

import SwiftUI
import UniformTypeIdentifiers

@available(iOS 14.0, *)
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showCameraView: Bool
    
    static var canCaptureImages: Bool {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return false
        }
        if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera),
            availableMediaTypes.contains(UTType.image.identifier) {
            return true
        }
        return false
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.mediaTypes = [UTType.image.identifier]
        imagePickerController.sourceType = .camera
        
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ cameraView: CameraView) {
            parent = cameraView
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.showCameraView = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCameraView = false
        }
    }
}
