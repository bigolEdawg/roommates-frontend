//
//  GroupViewModel.swift
//  roommates
//
//  Created by Elijah Matamoros on 1/2/26.
//

import Foundation
import FirebaseAuth

@MainActor
class GroupViewModel: ObservableObject {
    // MARK: - Published Properties (What the View displays)
    @Published var groups: [Group] = []           // List of groups to display
    @Published var isLoading = false              // Show loading indicator
    @Published var errorMessage: String = ""      // Show error messages
    
    // MARK: - Services
    private let backendService = BackendService()
    
    // MARK: - Methods (What the View can do)
    
    // Load groups from backend
    func loadGroups() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Call your Go backend API
            let groupDicts = try await backendService.getGroups()
            
            // Convert JSON dictionaries to Group objects
            groups = groupDicts.compactMap { dict in
                Group.fromDictionary(dict)
            }
        } catch {
            errorMessage = "Failed to load groups: \(error.localizedDescription)"
            print("Error loading groups: \(error)")
        }
        
        isLoading = false
    }
    
//    // Create a new group
//    func createGroup(name: String) async -> Bool {
//        guard !name.isEmpty else {
//            errorMessage = "Group name cannot be empty"
//            return false
//        }
//        isLoading = true
//        
//        do {
//            let newGroupDict = try await backendService.createGroup(name: name)
//            
//            // Add new group to our list
//            if let newGroup = Group.fromDictionary(newGroupDict) {
//                groups.append(newGroup)
//            }
//            
//            errorMessage = ""
//            return true
//        } catch {
//            errorMessage = "Failed to create group: \(error.localizedDescription)"
//            return false
//        }
//        defer {
//            isLoading = false
//        }
//    }
    
    // Delete a group
//    func deleteGroup(at indexSet: IndexSet) {
//        groups.remove(atOffsets: indexSet)
//        // TODO: Also delete from backend
//    }
}

// MARK: - Group Model
struct Group: Identifiable {
    let id: String
    let name: String
    let ownerId: String
    let createdAt: Date
    let members: [String]
    
    // Helper to create Group from JSON dictionary
    static func fromDictionary(_ dict: [String: Any]) -> Group? {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let ownerId = dict["ownerId"] as? String else {
            return nil
        }
        
        // Handle date conversion
        var createdAt = Date()
        if let timestamp = dict["createdAt"] as? String {
            let formatter = ISO8601DateFormatter()
            createdAt = formatter.date(from: timestamp) ?? Date()
        }
        
        let members = dict["members"] as? [String] ?? [ownerId]
        
        return Group(
            id: id,
            name: name,
            ownerId: ownerId,
            createdAt: createdAt,
            members: members
        )
    }
}







