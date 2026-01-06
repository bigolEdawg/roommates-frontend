// GroupView.swift
import SwiftUI
struct GroupView: View {
    let userId: String
    @StateObject private var groupVM = GroupViewModel()
    @StateObject private var choreVM = ChoreViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Groups")
                .font(.headline)
                .bold()
            
            // ✅ Use ViewModel's properties
            if groupVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if groupVM.groups.isEmpty {
                Text("No groups yet. Create one!")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                // ✅ Use ViewModel's groups (which are Identifiable)
//                List(groupVM.groups) { group in
//                    VStack(alignment: .leading) {
//                        Text(group.name)
//                            .font(.subheadline)
//                            .bold()
//                        Text("Created: \(formatDate(group.createdAt))")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
                // nav is for going to a new view
                // button is for actions
                List(groupVM.groups) { group in
                    NavigationLink(destination: ChoreView(groupID : group.id)) {
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.subheadline)
                                .bold()
                            
                            Text("Created: \(formatDate(group.createdAt))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 200)
            }
            
            // Create new group button - use ViewModel
            Button("Create New Group") {
                Task {
//                    _ = await groupVM.createGroup(name: "Test Group")
                }
            }
            .buttonStyle(.bordered)
            .disabled(groupVM.isLoading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .task {
            // ✅ Load via ViewModel
            await groupVM.loadGroups()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
//struct GroupView: View {
//    let userId: String
//    @StateObject private var groupVM = GroupViewModel()
//    @State private var groups: [[String: Any]] = []
//    @State private var isLoading = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Your Groups")
//                .font(.headline)
//                .bold()
//            
//            if isLoading {
//                ProgressView()
//                    .frame(maxWidth: .infinity)
//            } else if groups.isEmpty {
//                Text("No groups yet. Create one!")
//                    .foregroundColor(.gray)
//                    .font(.caption)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding()
//            } else {
//                List(groups, id: \.self) { group in
//                    VStack(alignment: .leading) {
//                        Text(group["name"] as? String ?? "Unnamed Group")
//                            .font(.subheadline)
//                            .bold()
//                        Text("Created: \(formatDate(group["createdAt"] as? Date))")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .frame(height: 200) // Fixed height for embedded list
//            }
//            
//            // Create new group button
//            Button("Create New Group") {
////                Task {
////                    await createNewGroup()
////                }
//            }
//            .buttonStyle(.bordered)
//            .disabled(isLoading)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(10)
//        .padding(.horizontal)
//        .task {
//            // Load groups when view appears
//            await loadGroups()
//        }
//    }
//    
//    private func loadGroups() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        do {
//            let backendService = BackendService()
//            groups = try await backendService.getGroups()
//        } catch {
//            print("Error loading groups: \(error)")
//        }
//    }
    
//    private func createNewGroup() async {
//        // Simple alert for group name - in production, use .alert or sheet
//        // For now, create a test group
//        let backendService = BackendService()
//        do {
//            let newGroup = try await backendService.createGroup(name: "Roommate Group \(Date().formatted())")
//            await loadGroups() // Refresh the list
//        } catch {
//            print("Error creating group: \(error)")
//        }
//    }
    
//    private func formatDate(_ date: Date?) -> String {
//        guard let date = date else { return "Unknown" }
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter.string(from: date)
//    }
//}


////
////  GroupView.swift
////  roommates
////
////  Created by Elijah Matamoros on 12/11/25.
////
//
//
//import SwiftUI
////
////struct ContentView: View {
////
////    var body: some View {
////        VStack {
////            TextField("email field")
////        }
////    }
////}
////
//
//import SwiftUI
//
//struct GroupView: View {
//    @StateObject private var authVM = AuthenticationViewModel()
//    @State private var isLoading = false
//    @State private var isSignUpMode = false  // Toggle between sign up/sign in
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Groups")
//                .font(.largeTitle)
//                .bold()
//            
//            if !authVM.errorMessage.isEmpty {
//                Text(authVM.errorMessage)
//                    .foregroundColor(.red)
//                    .font(.caption)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//            }
//            
//            // if user isnt nil
//            if let user = authVM.user {
//                // load in the Group view
//                VStack {
//                    Text("✅ Logged in as: \(user.email ?? "No email")")
//                        .foregroundColor(.green)
//                    
//                    Button("Sign Out") {
//                        Task {
//                            let success = await authVM.signOut()
//                            print("Sign out successful: \(success)")
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.red)
//                }
//            } else {
//                Button(action: {
//                    Task {
//                        isLoading = true
//                        if isSignUpMode {
//                            let success = await authVM.signUpWithEmailPassword()
//                            print("Sign up result: \(success)")
//                        } else {
//                            let success = await authVM.signInWithEmailPassword()
//                            print("Sign in result: \(success)")
//                        }
//                        isLoading = false
//                    }
//                }) {
//                    if isLoading {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    } else {
//                        Text(isSignUpMode ? "Sign Up" : "Sign In")
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(isLoading || authVM.email.isEmpty || authVM.password.isEmpty)
//                
//                Button(isSignUpMode ? "Already have an account? Sign In" : "Need an account? Sign Up") {
//                    isSignUpMode.toggle()
//                    authVM.errorMessage = ""  // Clear errors when switching modes
//                }
//                .buttonStyle(.borderless)
//                .foregroundColor(.blue)
//            }
//            
//            // Debug info
//            VStack {
//                Text("Debug Info:")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("Email: \(authVM.email)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("Password length: \(authVM.password.count)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("User logged in: \(authVM.user != nil ? "Yes" : "No")")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            .padding(.top)
//        }
//        .padding()
//        .onAppear {
//            // Print initial state
//            print("LoginView appeared")
//            print("Initial user: \(authVM.user?.email ?? "None")")
//        }
//    }
//}
//
//
//
//
