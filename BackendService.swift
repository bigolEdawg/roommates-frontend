import Foundation
import FirebaseAuth

// Define custom errors for your app
enum AppError: Error {
    case notLoggedIn
    case invalidResponse
    case networkError(Error)
}

class BackendService {
    // private let baseURL = "http://localhost:8080/api"
    private let baseURL = "http://127.0.0.1:5000/api"
    
    private func authenticatedRequest(_ endpoint: String) async throws -> Data {
        // Get token from Firebase
        guard let user = Auth.auth().currentUser,
              let token = try? await user.getIDToken() else {
            throw AppError.notLoggedIn  // Throw instead of print
        }
        
        let url = URL(string: "\(baseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP status code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                // You might want to parse error message from response
                let statusCode = httpResponse.statusCode
                throw AppError.networkError(
                    NSError(domain: "HTTP", code: statusCode, userInfo: nil)
                )
            }
            
            return data
        } catch {
            throw AppError.networkError(error)
        }
    }
    
    // Get user's groups
    func getGroups() async throws -> [[String: Any]] {
        let data = try await authenticatedRequest("/user/groups")
        print("trying to get data from api")
        print(data)
        return try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
    }
    
//    // Create new group
//    func createGroup(name: String) async throws -> [String: Any] {
//        guard let user = Auth.auth().currentUser,
//              let token = try? await user.getIDToken() else {
//            throw AppError.notLoggedIn  // Throw error instead of returning ""
//        }
//        
//        let url = URL(string: "\(baseURL)/user/groups")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body = ["name": name]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            // Check HTTP status
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw AppError.invalidResponse
//            }
//            
//            guard (200...299).contains(httpResponse.statusCode) else {
//                // Try to parse error message from response
//                if let errorDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                   let errorMessage = errorDict["error"] as? String {
//                    throw NSError(domain: "Backend", code: httpResponse.statusCode,
//                                 userInfo: [NSLocalizedDescriptionKey: errorMessage])
//                }
//                throw AppError.networkError(
//                    NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: nil)
//                )
//            }
//            
//            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                throw AppError.invalidResponse
//            }
//            
//            return json
//        } catch {
//            throw AppError.networkError(error)
//        }
//    }
}


////
////  BackendService.swift
////  roommates
////
////  Created by Elijah Matamoros on 12/14/25.
////
//
//import Foundation
//import FirebaseAuth
//
//class BackendService {
//    private let baseURL = "http://localhost:8080/api"
//    
//    private func authenticatedRequest(_ endpoint: String) async throws -> Data {
//        // Get token from Firebase
//        guard let user = Auth.auth().currentUser,   // verify that there isa current user
//              let token = try? await user.getIDToken() else {
//            print("Some error")
//        }
//        
//        let url = URL(string: "\(baseURL)\(endpoint)")!
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//        return data
//    }
//    
//    // Get user's groups
//    func getGroups() async throws -> [[String: Any]] {
//        let data = try await authenticatedRequest("/user/groups")
//        return try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
//    }
//    
//    // Create new group
//    func createGroup(name: String) async throws -> [String: Any] {
//        guard let user = Auth.auth().currentUser,
//              let token = try? await user.getIDToken() else {
////            throw AuthError.notLoggedIn
//            return ""
//        }
//        
//        let url = URL(string: "\(baseURL)/user/groups")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body = ["name": name]
//        request.httpBody = try JSONSerialization.data(withJSONObject: body)
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//        return try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
//    }
//}
