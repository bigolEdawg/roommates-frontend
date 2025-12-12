//
//  GroupView.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/11/25.
//


import SwiftUI
//
//struct ContentView: View {
//
//    var body: some View {
//        VStack {
//            TextField("email field")
//        }
//    }
//}
//

import SwiftUI

struct GroupView: View {
    @StateObject private var authVM = AuthenticationViewModel()
    @State private var isLoading = false
    @State private var isSignUpMode = false  // Toggle between sign up/sign in
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Groups")
                .font(.largeTitle)
                .bold()
            
            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // if user isnt nil
            if let user = authVM.user {
                // load in the Group view
                VStack {
                    Text("✅ Logged in as: \(user.email ?? "No email")")
                        .foregroundColor(.green)
                    
                    Button("Sign Out") {
                        Task {
                            let success = await authVM.signOut()
                            print("Sign out successful: \(success)")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            } else {
                Button(action: {
                    Task {
                        isLoading = true
                        if isSignUpMode {
                            let success = await authVM.signUpWithEmailPassword()
                            print("Sign up result: \(success)")
                        } else {
                            let success = await authVM.signInWithEmailPassword()
                            print("Sign in result: \(success)")
                        }
                        isLoading = false
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isSignUpMode ? "Sign Up" : "Sign In")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || authVM.email.isEmpty || authVM.password.isEmpty)
                
                Button(isSignUpMode ? "Already have an account? Sign In" : "Need an account? Sign Up") {
                    isSignUpMode.toggle()
                    authVM.errorMessage = ""  // Clear errors when switching modes
                }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
            }
            
            // Debug info
            VStack {
                Text("Debug Info:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Email: \(authVM.email)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Password length: \(authVM.password.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("User logged in: \(authVM.user != nil ? "Yes" : "No")")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top)
        }
        .padding()
        .onAppear {
            // Print initial state
            print("LoginView appeared")
            print("Initial user: \(authVM.user?.email ?? "None")")
        }
    }
}




