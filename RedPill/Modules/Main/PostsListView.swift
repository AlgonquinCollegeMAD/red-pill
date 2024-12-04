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
        if let imageURL = post.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                case .failure(_):
                    Image("ImageNotFound")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                @unknown default:
                    Image("ImageNotFound")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
            }
        } else {
            Image("NoImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
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
