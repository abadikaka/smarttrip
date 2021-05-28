//
//  SmartTripApp.swift
//  Shared
//
//  Created by Michael A.S & Prakosa A.S. on 18/5/2564 BE.
//

import Firebase
import SwiftUI

@main
struct SmartTripApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
