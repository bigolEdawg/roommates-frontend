//
//  AuthenticationViewModel.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/1/25.
//

import Foundation
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: User? // this is saying that user is the current user and nil otherwise
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool  {
        
        // this is for signing in with email
        /*
        the goal here is to use the firebase auth to authenticate where a user is in the db or not
        */
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
        } catch {
            
        }
        
        return true
    }
    
    func signUpWithEmailPassword() async -> Bool {
        return true
    }
    
    func signOut() async -> Bool   {
        return true
    }
    
    func deleteAccount() async -> Bool   {
        return true
    }
}



