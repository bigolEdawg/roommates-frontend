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


class CreateUser: ObservableObject {
    // configure firestore
    let db = Firestore.firestore()
    
    // save the unique id to firestore
    func saveToFirestore(uid: String) async throws{
        do {
            try await db.collection("users").document(uid).setData([
                "name" : "test"
            ])
        } catch {
            print(error)
        }
    }
    
}
