//
//  PostsListView.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import SwiftUI

struct PostsListView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var posts: [Post] = []

    var body: some View {
        List(databaseManager.posts) { post in
            HStack(alignment: .top, spacing: 15) {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text(post.content)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("by \(post.authorID)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Posts")
        .onAppear {
            Task {
                do {
                    self.posts = try await databaseManager.fetchPosts()
                } catch {
                    print(error)
                }
            }
        }
    }
}
