//
//  ChoreViewModel.swift
//  roommates
//
//  Created by Elijah Matamoros on 1/2/26.
//

import Foundation
import FirebaseAuth

@MainActor
class ChoreViewModel: ObservableObject {
    // MARK: - Published Properties (What the View displays)
    @Published var chores: [Chore] = []           // List of chores to display
    @Published var isLoading = false              // Show loading indicator
    @Published var errorMessage: String = ""      // Show error messages
    
    // MARK: - Services
    private let backendService = BackendService()
    
    // MARK: - Methods (What the View can do)
    
    // Load chores from backend
    func loadChores(group_id : String) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        do {
            // Call your Go backend API
            let choreDicts = try await backendService.getChores(group_id: group_id)
            
            // Convert JSON dictionaries to Chore objects
            chores = choreDicts.compactMap { dict in
                Chore.fromDictionary(dict)
            }
        } catch {
            errorMessage = "Failed to load chores: \(error.localizedDescription)"
            print("Error loading chores: \(error)")
        }
        
        isLoading = false
    }
    
// MARK: - Chore Model
    struct Chore: Identifiable {
        let id: String  // ⭐ MISSING THIS! All Identifiable must have 'id'
        let assignee: String
        let details: String
        let dueDate: String
        let frequency: String
        let name: String
        let groupId: String
        let createdAt: Date
        
        // Helper to create Chore from JSON dictionary
        static func fromDictionary(_ dict: [String: Any]) -> Chore? {
            // Extract required fields with fallbacks
            let id = dict["id"] as? String ?? UUID().uuidString
            let name = dict["name"] as? String ??
                       dict["chore_name"] as? String ??
                       "Unnamed Chore"
            let assignee = dict["assignee"] as? String ??
                          dict["chore_assignee"] as? String ??
                          "Unassigned"
            let details = dict["details"] as? String ??
                         dict["chore_details"] as? String ??
                         ""
            let dueDate = dict["dueDate"] as? String ??
                         dict["chore_due_date"] as? String ??
                         ""
            let frequency = dict["frequency"] as? String ??
                           dict["chore_frequency"] as? String ??
                           "Once"
            let groupId = dict["groupId"] as? String ??
                         dict["group_id"] as? String ??
                         ""
            
            // Handle date conversion
            var createdAt = Date()
            if let timestamp = dict["createdAt"] as? String {
                let formatter = ISO8601DateFormatter()
                createdAt = formatter.date(from: timestamp) ?? Date()
            } else if let timestamp = dict["createdAt"] as? TimeInterval {
                createdAt = Date(timeIntervalSince1970: timestamp)
            }
            
            return Chore(
                id: id,
                assignee: assignee,
                details: details,
                dueDate: dueDate,
                frequency: frequency,
                name: name,
                groupId: groupId,
                createdAt: createdAt
            )
        }
    }
}
