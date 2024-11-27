//
//  AuthService.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.27.
//

import SwiftUI
import FirebaseAuth

enum AuthServiceError: Error, Identifiable, LocalizedError {
  case loginFailed(String)
  case logoutFailed(String)
  case registrationFailed(String)
  case sendPasswordFailed(String)
  
  var id: String {
    switch self {
    case .loginFailed(_): return "loginFailed"
    case .logoutFailed(_): return "logoutFailed"
    case .registrationFailed(_): return "registrationFailed"
    case .sendPasswordFailed(_): return "sendPasswordFailed"
    }
  }
  
  var message: String {
    switch self {
    case .loginFailed(let message): return message
    case .logoutFailed(let message): return message
    case .registrationFailed(let message): return message
    case .sendPasswordFailed(let message): return message
    }
  }
}

class AuthService: ObservableObject {
  @Published var user: User?
  //  @Published var errorMessage: String?
  @Published var isSignedIn = false
  
  private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
  
  init() {
    self.user = Auth.auth().currentUser
    
    self.authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      self?.user = user
      self?.isSignedIn = user != nil
    }
  }
  
  func login(email: String, password: String) async throws {
    do {
      let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
      user = authResult.user
    } catch {
      print(error.localizedDescription)
      throw AuthServiceError.loginFailed(error.localizedDescription)
    }
  }
  
  func logout() throws {
    do {
      try Auth.auth().signOut()
      self.user = nil
    } catch {
      throw AuthServiceError.logoutFailed(error.localizedDescription)
    }
  }
  
  func createAccount(email: String, password: String) async throws {
    do {
      let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
      self.user = authResult.user
    } catch {
      throw AuthServiceError.registrationFailed(error.localizedDescription)
    }
  }
  
  func sendPasswordReset(email: String) async throws {
    do {
      try await Auth.auth().sendPasswordReset(withEmail: email)
    } catch {
      throw AuthServiceError.loginFailed(error.localizedDescription)
    }
  }
}

