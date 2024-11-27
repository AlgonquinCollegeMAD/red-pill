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
      VStack(alignment: .leading) {
        Text(post.content)
          .font(.headline)
        Text("by \(post.authorID)")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
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
