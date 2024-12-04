//
//  CreatePostView.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import SwiftUI
import FirebaseFirestore

struct CreatePostView: View {
  @EnvironmentObject var databaseManager: DatabaseManager
  @State private var postContent: String = ""
  @Environment(\.dismiss) private var dismiss
  @State private var isSubmitting = false
  @State private var showError = false
  @State private var errorMessage = ""
  
  var userID: String
  
  var body: some View {
    VStack(spacing: 16) {
      Text("Create a New Post")
        .font(.title2)
        .fontWeight(.bold)
        .padding(.top)
      
      VStack(alignment: .leading) {
        Text("Post Content")
          .font(.headline)
          .foregroundColor(.gray)

        ZStack(alignment: .topLeading) {
          if postContent.isEmpty {
            Text("Enter your post here...")
              .foregroundColor(.gray)
              .padding(.top, 8)
              .padding(.leading, 5)
          }
          
          TextEditor(text: $postContent)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .frame(height: 200)
        }
      }
      
      Button(action: submitPost) {
        if isSubmitting {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text("Post")
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
      .disabled(isSubmitting)
      .padding(.horizontal)
      .padding(.bottom)
      
    }
    .padding()
    .alert("Error", isPresented: $showError) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(errorMessage)
    }
  }
  
  private func submitPost() {
    guard !postContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      errorMessage = "Post content cannot be empty."
      showError = true
      return
    }
    
    isSubmitting = true
    
    Task {
      do {
        try await databaseManager.addPost(content: postContent, authorID: userID)
        dismiss()
      } catch {
        errorMessage = "Failed to submit post: \(error.localizedDescription)"
        showError = true
      }
      isSubmitting = false
    }
  }
}

#Preview {
  CreatePostView(userID: "123456")
}
