//
//  ForgotPasswordScreen.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.27.
//

import SwiftUI

struct ForgotPasswordScreen: View {
  @State private var email: String = ""
  @FocusState private var focus: Bool
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var authService: AuthService
  
  var body: some View {
    NavigationStack {
      VStack {
        TextField("Enter your email", text: $email)
          .padding()
          .autocapitalization(.none)
          .focused($focus)
          .onAppear() { focus = true }
        
        Button("Request Password Reset") {
          Task {
            do {
              try await authService.sendPasswordReset(email: email)
              dismiss()
            } catch {
              print(error)
            }
          }
        }
        .algonquinButtonStyle(backgroundColor: .blue, disabled: email.isEmpty)
      }
      .padding()
      .navigationTitle("Forgot Password")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  ForgotPasswordScreen()
}
