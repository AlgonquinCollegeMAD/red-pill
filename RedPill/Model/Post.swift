//
//  Post.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Identifiable {
  @DocumentID var id: String?
  var content: String
  var authorID: String
  var timestamp: Date
  var imageURL: URL?
}
