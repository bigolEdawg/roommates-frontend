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
      let settings = Firestore.firestore().settings
      settings.host = "127.0.0.1:8080"
      settings.cacheSettings = MemoryCacheSettings()
      settings.isSSLEnabled = false
      Firestore.firestore().settings = settings
    
    Auth.auth().useEmulator(withHost: "localhost", port: 9099)
//    print("Firebase Configured!")
    print("Firebase Configured with Emulators!")
    print("Auth Emulator: localhost:9099")
    print("Firestore Emulator: localhost:8080")
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


