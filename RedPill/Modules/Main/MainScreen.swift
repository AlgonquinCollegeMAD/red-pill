
//
//  MainScreen.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.28.
//

import SwiftUI

struct MainScreen: View {
  @EnvironmentObject var authService: AuthService
  @State private var showCreatePostView = false
  
  var body: some View {
    NavigationStack {
      PostsListView()
        .navigationTitle("Red Pill")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: SettingsScreen()) {
              Image(systemName: "gearshape")
            }
          }
          ToolbarItem(placement: .bottomBar) {
            Button(action: {
              showCreatePostView = true
            }) {
              Text("Create Post")
            }
          }
        }
        .sheet(isPresented: $showCreatePostView) {
          CreatePostView(userID: authService.user?.email ?? "Unknown")
        }
    }
  }
}

#Preview {
  MainScreen()
}
