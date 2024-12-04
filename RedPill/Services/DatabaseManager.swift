//
//  DatabaseManager.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//


import Firebase

class DatabaseManager: ObservableObject {
  @Published var posts: [Post] = []
  private let db = Firestore.firestore()
  
  @MainActor
  init() {
    db
      .collection("posts")
      .order(by: "timestamp", descending: true)
      .addSnapshotListener { snapshot, error in
        guard let snapshot = snapshot else {
          print("Error fetching updates: \(error?.localizedDescription ?? "Unknown error")")
          return
        }
        
        let newPosts = snapshot.documents.compactMap { document -> Post? in
          try? document.data(as: Post.self)
        }
        
        self.posts = newPosts
      }
  }
  
  func fetchPosts() async throws -> [Post] {
    let querySnapshot = try await db.collection("posts")
      .order(by: "timestamp", descending: true)
      .getDocuments()
    
    return querySnapshot.documents.compactMap { try? $0.data(as: Post.self) }
  }
  
  func addPost(content: String, authorID: String, imageURL: URL?) async throws {
    let newPost = Post(content: content, authorID: authorID, timestamp: Date(), imageURL:imageURL)
    try db.collection("posts").addDocument(from: newPost)
  }
}
