//
//  Untitled.swift
//  roommates
//
//  Created by Elijah Matamoros on 1/6/26.
//

import SwiftUI
struct MemberView: View {
    //let userId: String
    let groupID: String
    @StateObject private var memberVM = MemberViewModel()
 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Members")
                .font(.headline)
                .bold()
            
            // ✅ Use ViewModel's properties
            if memberVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if memberVM.members.isEmpty {
                Text("No members")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                // ✅ Use ViewModel's members (which are Identifiable)
                List(memberVM.members) { member in
                    VStack(alignment: .leading) {
                        Text(member.user_name)
                            .font(.subheadline)
                            .bold()
//                        Text("Created: \(formatDate(member.joined_at))")
//                            .font(.caption)
//                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 200)
            }
            
            // Create new member button - use ViewModel
            Button("Add Member") {
                Task {
//                    _ = await memberVM.createGroup(name: "Test Member")
                }
            }
            .buttonStyle(.bordered)
            .disabled(memberVM.isLoading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .task {
            // ✅ Load via ViewModel
            await memberVM.loadMembers(group_id: groupID)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
