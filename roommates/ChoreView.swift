//
//  ChoreView.swift
//  roommates
//
//  Created by Elijah Matamoros on 1/2/26.
//

import SwiftUI
struct ChoreView: View {
    //let userId: String
    let groupID: String
    @StateObject private var choreVM = ChoreViewModel()
 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Chores")
                .font(.headline)
                .bold()
            
            // ✅ Use ViewModel's properties
            if choreVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if choreVM.chores.isEmpty {
                Text("No chores yet. Create one!")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                // ✅ Use ViewModel's chores (which are Identifiable)
                List(choreVM.chores) { chore in
                    VStack(alignment: .leading) {
                        Text(chore.name)
                            .font(.subheadline)
                            .bold()
                        Text("Created: \(formatDate(chore.createdAt))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 200)
            }
            
            // Create new chore button - use ViewModel
            Button("Create New Chore") {
                Task {
//                    _ = await choreVM.createGroup(name: "Test Chore")
                }
            }
            .buttonStyle(.bordered)
            .disabled(choreVM.isLoading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .task {
            // ✅ Load via ViewModel
            await choreVM.loadChores(group_id: groupID)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
