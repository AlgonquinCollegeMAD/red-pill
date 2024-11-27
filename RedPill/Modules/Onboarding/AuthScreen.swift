//
//  AuthScreen.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.27.
//
import SwiftUI

struct AuthScreen: View {
  @State private var email: String = .init()
  @State private var password: String = .init()
  @EnvironmentObject private var authService: AuthService
  @State private var showForgotPasswordSheet: Bool = false
  @FocusState private var focus
  @State private var authServiceError: AuthServiceError?
  
  private var isFormValid: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  var body: some View {
    NavigationStack {
      VStack {
        TextField("Email", text: $email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocapitalization(.none)
          .keyboardType(.emailAddress)
          .focused($focus)
          .onAppear() { focus = true }
        
        SecureField("Password", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        HStack {
          Button("Login") { login() }
            .algonquinButtonStyle(backgroundColor: .blue, disabled: !isFormValid)
          
          Button("Create") { createAccount() }
            .algonquinButtonStyle(backgroundColor: .blue, disabled: !isFormValid)
            .padding()
        }
        
        Button("Forgot password") { forgotPassword() }
        
      }
      .padding()
      .navigationTitle("Login")
      .alert(item: $authServiceError) { error in
        Alert(title: Text("Login Error"), message: Text(error.message))
      }
      .sheet(isPresented: $showForgotPasswordSheet) {
        ForgotPasswordScreen()
      }
    }
  }
  
  func login() {
    Task {
      do {
        try await authService.login(email: email, password: password)
      } catch {
        authServiceError = error as? AuthServiceError
      }
    }
  }
  
  func createAccount() {
    Task {
      try? await authService.createAccount(email: email, password: password)
    }
  }
  
  func forgotPassword() {
    showForgotPasswordSheet.toggle()
  }
}

#Preview {
  AuthScreen()
}
