//
//  Dog_KeyboardApp.swift
//  Dog Keyboard
//
//  Created by Johnny Archard on 11/21/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct Dog_KeyboardApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
