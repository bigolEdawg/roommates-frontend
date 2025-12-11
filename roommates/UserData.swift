//
//  Untitled.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/10/25.
//

import FirebaseFirestore
// get data from firestore
class UserData {
    let db = Firestore.firestore()
    
    
    func getUserData(uid : String) {
        db.collection("users")
    }
    
    
}



