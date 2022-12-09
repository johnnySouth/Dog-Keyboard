//
//  ImagePicker.swift
//  Dog Keyboard
//
//  Created by Johnny Archard on 11/25/22.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator// object that can receive uiimagepicker controller events
        
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Run Code when user cancels picker ui
        print("canceled")
        
        //Dismiss the picker
        parent.isPickerShowing = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Run the code when the user has selected an imamge
        print("image selected")
        
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            // we were able to get the image
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
           
        }
        // Dismiss Picker
        parent.isPickerShowing = false
    }
}


