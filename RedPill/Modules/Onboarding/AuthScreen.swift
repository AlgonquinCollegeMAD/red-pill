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
  @State private var isLoading: Bool = false
  
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
            Button(action: { login() }) {
                HStack {
                    if isLoading {
                        ProgressView() // Added spinner
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text("Login")
                }
            }
            .algonquinButtonStyle(backgroundColor: .blue, disabled: !isFormValid || isLoading)
          
            Button(action: { createAccount() }) {
                HStack {
                    if isLoading {
                        ProgressView() // Added spinner
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text("Create")
                }
            }
            .algonquinButtonStyle(backgroundColor: .blue, disabled: !isFormValid || isLoading)
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
    .disabled(isLoading)
    .opacity(isLoading ? 0.6 : 1)
  }
  
  func login() {
    Task {
        
      do {
        isLoading = true
        try await authService.login(email: email, password: password)
      } catch {
        authServiceError = error as? AuthServiceError
      }
      isLoading = false
    }
  }
  
  func createAccount() {
    Task {
      isLoading = true
      try? await authService.createAccount(email: email, password: password)
      isLoading = false
    }
  }
  
  func forgotPassword() {
    showForgotPasswordSheet.toggle()
  }
}

#Preview {
  AuthScreen()
}
