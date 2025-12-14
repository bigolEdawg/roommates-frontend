//
//  TokenService.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/13/25.
//

import FirebaseAuth

class TokenService {
    static let shared = TokenService()
    
    // Get current ID token
    func getIDToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.notLoggedIn
        }
        
        return try await user.getIDToken()
    }
    
    // Force refresh if needed (tokens expire after 1 hour)
    func getFreshIDToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.notLoggedIn
        }
        
        return try await user.getIDToken(forcingRefresh: true)
    }
}

// API Service using token
class APIService {
    private let baseURL = "https://your-go-backend.com/api"
    
    // Generic authenticated request
    private func authenticatedRequest(
        path: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> Data {
        let token = try await TokenService.shared.getIDToken()
        let url = URL(string: "\(baseURL)\(path)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    // Get user's groups
    func getUserGroups() async throws -> [UserGroup] {
        let data = try await authenticatedRequest(path: "/user/groups")
        return try JSONDecoder().decode([UserGroup].self, from: data)
    }
    
    // Create new group
    func createGroup(name: String) async throws -> UserGroup {
        let body = try JSONEncoder().encode(["name": name])
        let data = try await authenticatedRequest(
            path: "/user/groups",
            method: "POST",
            body: body
        )
        return try JSONDecoder().decode(UserGroup.self, from: data)
    }
}
