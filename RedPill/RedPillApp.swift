//
//  RedPillApp.swift
//  RedPill
//
//  Created by Vladimir Cezar on 2024.11.27.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct RedPillApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authService: AuthService = .init()
  @StateObject var databaseManager: DatabaseManager = .init()
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(authService)
        .environmentObject(databaseManager)
    }
  }
}
