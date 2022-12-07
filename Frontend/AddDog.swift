//
//  AddDog.swift
//  Dog Keyboard
//
//  Created by Johnny Archard on 12/6/22.
//


import SwiftUI
import Firebase

struct AddDog: View {
    
    @State private var nameOfDog: String = ""
    @State private var dogNames: [String] = []
    @State private var showAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter new dog name", text: $nameOfDog)
                .padding()
                .frame(width: 200, height:50, alignment: .center)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                Text("                       ")
                Button("Add dog"){
                addDogNames()
                    showAlert = true
                } .alert(nameOfDog + " was added to the database.", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                Text("                       ")
                NavigationLink(destination: homePage()) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(darkBlueColor)
                    Text("Home")
                }

            }
        } .accentColor(darkBlueColor)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
        
        
    }
    func addDogNames(){
        let db = Firestore.firestore()
        let dogName = nameOfDog
        
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("Dogs").addDocument(data: [
            "name": dogName,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    struct AddDog_Previews: PreviewProvider {
        static var previews: some View {
            AddDog()
        }
    }
}

