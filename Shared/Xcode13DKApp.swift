//
//  Xcode13DKApp.swift
//  Shared
//
//  Created by Johnny Archard on 11/8/22.
//

import SwiftUI
import Firebase



@main
struct Xcode13DKApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
