//
//  CreateUser.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/8/25.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore

// I am considering making the initial sign up screen be 


class CreateUser: ObservableObject {
    // configure firestore
    let db = Firestore.firestore()
    
    // save the unique id to firestore
//    func saveToFirestore(uid: String, name: String, dob: String, username: String) async throws{
//        do {
//            try await db.collection("users").document(uid).setData([
//                "name"        : name,
//                "dob"         : dob,
//                "username"    : username
//            ])
//            print("saved \(name) with \(uid) to users collection")
//        } catch {
//            print("error saving the \(name) to firestore error")
//        }
//    }
    func saveToFirestore(uid: String, name: String) async throws{
        do {
            try await db.collection("users").document(uid).setData([
                "name"        : name,

            ])
            print("saved \(name) with \(uid) to users collection")
        } catch {
            print("error saving the \(name) to firestore error")
        }
    }

    func saveUIDToFirestore(uid: String) async throws{
        do {
            try await db.collection("users").document(uid).setData([
                "uid"        : uid,
            ])
            print("saved \(uid) to users collection")
        } catch {
            print("error saving the \(uid) to firestore error")
        }
    }

//    func validateUsername(nameCheck: String) async -> Bool{
//        // check that username contains spaces
//        // if it does refuses the sign up and send a warning that username cannot have spaces
//        if nameCheck.contains(" ") || nameCheck.contains("/") {
//            return false
//        }
//        return true
//    }
//    
//    //Check if the username exist or not
//    func checkUsername() {
//        do {
//            try
//        } catch {
//            
//        }
//    }
    
}
