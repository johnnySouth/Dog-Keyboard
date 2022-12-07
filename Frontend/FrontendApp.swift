//
//  FrontendApp.swift
//  Frontend
//
//  Created by Johnny Archard on 12/6/22.
//

import SwiftUI
import Firebase


@main
struct FrontendApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
