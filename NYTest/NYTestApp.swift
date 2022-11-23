//
//  NYTestApp.swift
//  NYTest
//
//  Created by Ludvig Krantzén on 2022-11-23.
//

import SwiftUI

@main
struct NYTestApp: App {
    
 //   @StateObject private var dataController = DataController()
    
    let persistantContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        //        .environment(\.managedObjectContext, dataController.container.viewContext)
                .environment(\.managedObjectContext, persistantContainer.viewContext)
        }
    }
}
