//
//  StorageManager.swift
//  Firebase Storage Demo
//
//  Created by Vladimir Cezar on 2024.12.03.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
  static let shared = StorageManager()
  private let storage = Storage.storage().reference()
  
  private init() {}
  
  func uploadImage(_ image: UIImage, forUserID userID: String) async throws -> URL {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
      throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
    }
    
    let imageID = UUID().uuidString
    let imageRef = storage.child("images/\(userID)/\(imageID).jpg")
    
    _ = try await imageRef.putDataAsync(imageData, metadata: nil)
    return try await imageRef.downloadURL()
  }
  
  func fetchImageURLs(forUserID userID: String) async throws -> [URL] {
    let userImagesRef = storage.child("images/\(userID)")
    let result = try await userImagesRef.listAll()
    
    return try await withThrowingTaskGroup(of: URL.self) { group in
      for item in result.items {
        group.addTask {
          return try await item.downloadURL()
        }
      }
      return try await group.reduce(into: [URL]()) { $0.append($1) }
    }
  }
}
