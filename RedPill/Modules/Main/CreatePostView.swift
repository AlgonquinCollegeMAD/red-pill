//
//  CreatePostView.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//


import SwiftUI
import FirebaseFirestore

import SwiftUI
import FirebaseFirestore

struct CreatePostView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var postContent: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    var userID: String
    
    var body: some View {
        VStack {
            AppPickerView(selectedImage: $selectedImage)
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            }
            
            TextEditor(text: $postContent)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 200)
                .cornerRadius(8)
            
            Button(action: submitPost) {
                if isSubmitting {
                    ProgressView()
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
            .disabled(isSubmitting || postContent.isEmpty)
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
        guard !postContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSubmitting = true
        
        Task {
            do {
                var imageURL: URL? = nil
                
                if let selectedImage = selectedImage {
                    isUploading = true
                    imageURL = try await StorageManager.shared.uploadImage(selectedImage, forUserID: userID)
                    isUploading = false
                }
                
                try await databaseManager.addPost(content: postContent, authorID: userID, imageURL: imageURL)
                dismiss()
            } catch {
                isSubmitting = false
                isUploading = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}


#Preview {
    CreatePostView(userID: "123456")
}
