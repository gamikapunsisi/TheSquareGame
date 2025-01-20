//
//  TheSqareGameApp.swift
//  TheSqareGame
//
//  Created by Gamika Punsisi on 2024-12-15.
//

//import SwiftUI
//
//@main
//struct TheSqareGameApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//



import SwiftUI

@main
struct TheSquareGameApp: App {
    @State private var isLoading = true // Tracks whether the app is in the loading phase

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingPage(isLoading: $isLoading) // Show the loading page
            } else {
                ContentView() // Show the main game screen
            }
        }
    }
}

