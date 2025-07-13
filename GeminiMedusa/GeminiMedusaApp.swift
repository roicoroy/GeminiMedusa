//
//  GeminiMedusaApp.swift
//  GeminiMedusa
//
//  Created by Ricardo Bento on 04/07/2025.
//

import SwiftUI
import SwiftData

@main
struct GeminiMedusaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject var cartService = CartService()

    var body: some Scene {
        WindowGroup {
            TabView {
                ProductsView()
                    .tabItem {
                        Label("Products", systemImage: "list.bullet")
                    }
                CartView()
                    .tabItem {
                        Label("Cart", systemImage: "cart.fill")
                    }
                    .badge(cartService.currentCart?.itemCount ?? 0)
                DebugView()
                    .tabItem {
                        Label("Debug", systemImage: "ant.fill")
                    }
            }
            .environmentObject(RegionService())
            .environmentObject(ProductsViewModel())
            .environmentObject(CartService())
        }
        .modelContainer(sharedModelContainer)
    }
}
