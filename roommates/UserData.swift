//
//  Untitled.swift
//  roommates
//
//  Created by Elijah Matamoros on 12/10/25.
//

import Foundation

class UserData {
    struct Chore : Codable {
        let user_id: String?
        let group_id: String?
        let chore_name: String?
        let chore_details: String?
        let chore_due_date: String?
        let chore_frequency: String?
        let chore_assignee: String?
    }
    let decoder = JSONDecoder()
    func getChoreData(groupId : String) async -> [Chore]{
        let urlString = "https://us-central1-roommates-473217.cloudfunctions.net/get-chore?group_id=" + groupId
        guard let url = URL(string : urlString) else {
            print("Invalid group id")
            return []
        }
        
        do {
            // call the url
            let (data, response) = try await URLSession.shared.data(from : url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return []
            }
            
            // decode the json. Remember that we can't just return data because at this point data is a JSON
            let chores = try decoder.decode([Chore].self, from: data)
            print("SUCCESS!\n")
            print("\(chores)")
            return chores
        } catch {
            print("error calling get-chore API: \(error)")
            return []
        }
    }
}

