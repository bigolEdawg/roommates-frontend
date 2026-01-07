//
//  MemberViewModel.swift
//  roommates
//
//  Created by Elijah Matamoros on 1/6/26.
//


import Foundation
import FirebaseAuth

@MainActor
class MemberViewModel: ObservableObject {
    // MARK: - Published Properties (What the View displays)
    @Published var members: [Member] = []           // List of members to display
    @Published var isLoading = false              // Show loading indicator
    @Published var errorMessage: String = ""      // Show error messages
    
    // MARK: - Services
    private let backendService = BackendService()
    
    // MARK: - Methods (What the View can do)
    
    // Load members from backend
    func loadMembers(group_id : String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Call your Go backend API
            let memberDicts = try await backendService.getMembers(group_id: group_id)
            
            // Convert JSON dictionaries to Member objects
            members = memberDicts.compactMap { dict in
                Member.fromDictionary(dict)
            }
        } catch {
            errorMessage = "Failed to load members: \(error.localizedDescription)"
            print("Error loading members: \(error)")
        }
        
        isLoading = false
    }
    
// MARK: - Member Model
    struct Member: Identifiable {
        let id: String
        let added_by: String
        let joined_at: String
        let user_id: String
        let user_name: String
        let groupId: String

        
        // Helper to create Member from JSON dictionary
        static func fromDictionary(_ dict: [String: Any]) -> Member? {
            // Extract required fields with fallbacks
            let user_id = dict["user_id"] as? String ?? UUID().uuidString
            let id = dict["id"] as? String ?? UUID().uuidString
//            let name = dict["name"] as? String ??
//                       dict["member_name"] as? String ??
//                       "Unnamed Member"
            let user_name = dict["user_name"] as? String ??
                       "Unnamed Member"
            let joined_at = dict["joined_at"] as? String ??
                        dict["joined_at"] as? String ??
                       ""
            let added_by = dict["added_by"] as? String ??
                         dict["added_by"] as? String ??
                         ""
            let groupId = dict["groupId"] as? String ??
                         dict["group_id"] as? String ??
                         ""
            
            // Handle date conversion
//            var createdAt = Date()
//            if let timestamp = dict["createdAt"] as? String {
//                let formatter = ISO8601DateFormatter()
//                createdAt = formatter.date(from: timestamp) ?? Date()
//            } else if let timestamp = dict["createdAt"] as? TimeInterval {
//                createdAt = Date(timeIntervalSince1970: timestamp)
//            }
//            
            return Member(
                id: id,
                added_by: added_by,
                joined_at: joined_at,
                user_id: user_id,
                user_name: user_name,
                groupId: groupId
            )
        }
    }
}
