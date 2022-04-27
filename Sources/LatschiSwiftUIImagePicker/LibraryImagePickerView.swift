//
//  ImagePickerView.swift
//  LatschiSwiftUIImagePicker
//
//  Created by Nils Leistner on 15.04.22.
//

import PhotosUI
import SwiftUI

@available(iOS 14, *)
public struct LibraryImagePickerView: UIViewControllerRepresentable {
    @Binding var showImagePickerView: Bool
    @State var imagePickerConfiguration: PHPickerConfiguration?
    var action: ([Data]?) -> Void
    
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
        let parent: LibraryImagePickerView
        
        init(_ libraryPickerView: LibraryImagePickerView) {
            parent = libraryPickerView
        }
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var images: [Data] = []
            for result in results {
                result.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { object, error in
                    if let error = error {
                        print("Can't load image \(error.localizedDescription)")
                    } else {
                        images.append(object!)
                    }
                }
            }
            self.parent.action(images)
            
            dismissImagePickerViewController()
        }
        
        private func dismissImagePickerViewController() {
            Task {
                await MainActor.run {
                    parent.showImagePickerView = false
                }
            }
        }
    }
}
