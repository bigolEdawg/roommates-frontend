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
    
    // Get user's chore
    // http://127.0.0.1:5000/api/group/chore?group-id=3
    func getChores(group_id : String) async throws -> [[String: Any]] {
        let data = try await authenticatedRequest("/group/chore?group-id=\(group_id)")
        print("trying to get data from api...calling chore")
        print(data)
        return try JSONSerialization.jsonObject(with: data) as? [[String: Any]] ?? []
    }
}
