//
//  roommatesApp.swift
//  roommates
//
//  Created by Elijah Matamoros on 9/26/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    let db = Firestore.firestore()
    
    Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    print("Firebase Configured!")
    return true
  }
}

@main
struct roommatesApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


