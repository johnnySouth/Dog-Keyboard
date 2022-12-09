//
//  testContentView.swift
//  Dog Keyboard
//
//  Created by Johnny Archard on 11/25/22.
//

import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestore

struct selectPhotoView: View {
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    
    var body: some View {
        VStack{
            if selectedImage != nil{
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 300, height: 200)
            }
            
            Button{
                isPickerShowing = true
            } label: {
                Text("Select a photo")
            }
            
            // upload Button
            if selectedImage != nil{
                Button {
                    //upload image
                    uploadFeelings()
                } label: {
                    Text("upload feelings")
                }
                Button {
                    //upload image
                    uploadActions()
                } label: {
                    Text("upload Actions")
                }
                Button {
                    //upload image
                    uploadPlaces()
                } label: {
                    Text("upload Places")
                }
                Button {
                    //upload image
                    uploadThings()
                } label: {
                    Text("upload Things")
                }
            }
            
            Divider()
            VStack{
                // Loop through the images and display them
                ForEach(retrievedImages, id: \.self){image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                }
               // print(retrievedImages.randomElement());
            }
        } .sheet(isPresented: $isPickerShowing, onDismiss: nil){
            ImagePicker(selectedImage: $selectedImage,isPickerShowing: $isPickerShowing)
        }
        .onAppear{
            retrievePhotos()
        }
    }
    func uploadFeelings(){
        
        guard selectedImage != nil else{
            return
        }
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else{
            return
        }
        
        let path = "Feelings/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
            
            if error == nil && metadata != nil{
                
                // Todo save refrence to file in Firestore DB
                let db = Firestore.firestore()
                db.collection("Feelings").document().setData(["url":path]) { error in
                    
                    // If there were no errors display the image
                    if error == nil {
                        
                        DispatchQueue.main.async {
                            // Add the uploaded image to the list of images for display
                                  self.retrievedImages.append(self.selectedImage!)
                        }
              
                        }
                    
                    }
                }
                    
                    
            }
        }
    func uploadPlaces() {
         
         guard selectedImage != nil else{
             return
         }
         let storage = Storage.storage()
         
         let storageRef = storage.reference()
         
         let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
         guard imageData != nil else{
             return
         }
         
         let path = "Places/\(UUID().uuidString).jpg"
         let fileRef = storageRef.child(path)
         
         let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
             
             if error == nil && metadata != nil{
                 
                 // Todo save refrence to file in Firestore DB
                 let db = Firestore.firestore()
                 db.collection("Places").document().setData(["url":path]) { error in
                     
                     // If there were no errors display the image
                     if error == nil {
                         
                         DispatchQueue.main.async {
                             // Add the uploaded image to the list of images for display
                                   self.retrievedImages.append(self.selectedImage!)
                         }
               
                         }
                     
                     }
                 }
                     
                     
             }
         }

    func uploadThings() {
         
         guard selectedImage != nil else{
             return
         }
         let storage = Storage.storage()
         
         let storageRef = storage.reference()
         
         let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
         guard imageData != nil else{
             return
         }
         
         let path = "Things/\(UUID().uuidString).jpg"
         let fileRef = storageRef.child(path)
         
         let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
             
             if error == nil && metadata != nil{
                 
                 // Todo save refrence to file in Firestore DB
                 let db = Firestore.firestore()
                 db.collection("Things").document().setData(["url":path]) { error in
                     
                     // If there were no errors display the image
                     if error == nil {
                         
                         DispatchQueue.main.async {
                             // Add the uploaded image to the list of images for display
                                   self.retrievedImages.append(self.selectedImage!)
                         }
               
                         }
                     
                     }
                 }
                     
                     
             }
         }

    func uploadActions() {
         
         guard selectedImage != nil else{
             return
         }
         let storage = Storage.storage()
         
         let storageRef = storage.reference()
         
         let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
         guard imageData != nil else{
             return
         }
         
         let path = "Actions/\(UUID().uuidString).jpg"
         let fileRef = storageRef.child(path)
         
         let uploadTask = fileRef.putData(imageData!,metadata: nil) { metadata, error in
             
             if error == nil && metadata != nil{
                 
                 // Todo save refrence to file in Firestore DB
                 let db = Firestore.firestore()
                 db.collection("Actions").document().setData(["url":path]) { error in
                     
                     // If there were no errors display the image
                     if error == nil {
                         
                         DispatchQueue.main.async {
                             // Add the uploaded image to the list of images for display
                                   self.retrievedImages.append(self.selectedImage!)
                         }
               
                         }
                     
                     }
                 }
                     
                     
             }
         }

    func retrievePhotos() {
        // Get the data from database
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil{
                
                var paths = [String]()
                
                //Loop througn all the returned docs
                for doc in snapshot!.documents {
                    // Extract the file path
                    paths.append(doc["url"] as! String)
                }
                
                //Loop through each file path and fetch the data from storage
                for path in paths {
                    // Get a reference to storage
                    let storageRef = Storage.storage().reference()
                  
                    // Specify the path
                    let fileRef = storageRef.child(path)
                    
                    // Retrieve the data
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                       
                        // Check for erros
                        if error == nil && data != nil {
                            
                            // Create a UiImage and put it into our array for display
                            if  let image = UIImage(data: data!){
                                
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    
                    } // End of Loop through paths
                }
            }
            
        }
    }
}
    

struct testContentView_Previews: PreviewProvider {
    static var previews: some View {
        selectPhotoView()
    }
}

