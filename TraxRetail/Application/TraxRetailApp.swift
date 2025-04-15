//
//  TraxRetailApp.swift
//  TraxRetail
//
//  Created by Tushar Gupta on 01/04/2025.
//

import SwiftUI

@main
struct TraxRetailApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if TraxRetailApp.isProduction() {
                AppFlowCoordinator
                    .shared
                    .start()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
    
    private static func isProduction() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }
}
