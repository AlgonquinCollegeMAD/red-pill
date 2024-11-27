//
//  ContentView.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.27.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var authService: AuthService
  
  var body: some View {
    NavigationStack {
      if authService.isSignedIn {
        MainScreen()
      } else {
        AuthScreen()
      }
    }
    .padding()
  }
}
