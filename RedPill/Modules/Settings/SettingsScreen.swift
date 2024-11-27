//
//  SettingsScreen.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import SwiftUI

struct SettingsScreen: View {
  @EnvironmentObject private var authService: AuthService
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("General")) {
          NavigationLink(destination: AboutScreen()) {
            HStack {
              Image(systemName: "info.circle")
              Text("About")
            }
          }
        }
        
        Section {
          HStack {
            Spacer()
            Button(action: {
              try? authService.logout()
              dismiss()
            }) {
              HStack {
                Text("Log out")
              }
              .foregroundColor(.red)
            }
            Spacer()
          }
        }
      }
      .navigationTitle("Settings")
    }
  }
}

#Preview {
  SettingsScreen()
}
