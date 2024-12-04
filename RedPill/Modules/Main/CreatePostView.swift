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
    @State private var selectedImage: UIImage?
    @State private var uploadedimageURLs: [URL] = []
    @State private var isUploading = false
    @State private var imageURL: URL? = nil
    
    var userID: String
    
    var body: some View {
        VStack {
            TextEditor(text: $postContent)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 200)
                .cornerRadius(8)
            AppPickerView(selectedImage: $selectedImage)
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Button("Upload Photo") {
                    Task {
                        await uploadPhoto(image)
                    }
                }
                .disabled(isUploading)
            }
            
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
                isSubmitting = false
                try await databaseManager.addPost(content: postContent, authorID: userID, imageURL: imageURL)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func uploadPhoto(_ image: UIImage) async {
        isUploading = true
        do {
            let url = try await StorageManager.shared.uploadImage(image, forUserID: userID)
            uploadedimageURLs.append(url)
            imageURL = url
        } catch {
            print("Upload failed: \(error.localizedDescription)")
        }
        isUploading = false
    }
}


#Preview {
    CreatePostView(userID: "123456")
}
