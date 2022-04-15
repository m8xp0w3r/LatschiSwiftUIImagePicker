//
//  ImagePickerView.swift
//  LatschiSwiftUIImagePicker
//
//  Created by Nils Leistner on 15.04.22.
//

import PhotosUI
import SwiftUI

@available(iOS 14, *)
public struct SingleLibraryPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePickerView: Bool
    @State var imagePickerConfiguration: PHPickerConfiguration?
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration: PHPickerConfiguration
        if self.imagePickerConfiguration == nil {
            configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 1
        } else {
            configuration = self.imagePickerConfiguration!
        }
        
        let imagePickerViewController = PHPickerViewController(configuration: configuration)
        imagePickerViewController.delegate = context.coordinator
        return imagePickerViewController
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: PHPickerViewControllerDelegate {
        let parent: SingleLibraryPickerView
        
        init(_ libraryPickerView: SingleLibraryPickerView) {
            parent = libraryPickerView
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.count == 1 {
                let image = results[0]
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            // Add new image and pass it back to the main view
                            self?.parent.image = image
                        }
                    }
                } else {
                    print("Can't load asset")
                }
            } else {
                print("Invalid count of photos selected: " + String(results.count))
            }
            parent.showImagePickerView = false
        }
    }
}
