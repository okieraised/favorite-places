//
//  FavoritePlacesApp.swift
//  FavoritePlaces
//
//  Created by Tri Pham on 3/1/23.
//

import SwiftUI

@main
struct FavoritePlacesApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var mapSettings = MapSettings()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(homeViewModel)
                .environmentObject(mapSettings)
            
        }
    }
}
