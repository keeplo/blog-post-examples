//
//  ImagePicker.swift
//  RealtimeVision
//
//  Created by 김용우 on 2023/07/04.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
    
}

extension ImagePicker {
    
    final class Coordinator: NSObject, ImagePickerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
}
