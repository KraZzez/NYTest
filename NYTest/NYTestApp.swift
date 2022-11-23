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
    
  //  let persistenceController = PersistenceController.shared
    
  //  @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistantContainer.viewContext)
        }
    }
}

//        .environment(\.managedObjectContext, dataController.container.viewContext)

/*               .environment(\.managedObjectContext, persistenceController.container.viewContext)
       }
       .onChange(of: scenePhase) { (newScenePhase) in
           switch newScenePhase {
           case .background:
               print("Scene is in background")
               persistenceController.save()
           case .inactive:
               print("Scene is inactive")
           case .active:
               print("Scene is active")
           @unknown default:
               print("Apple must have changed something")
           }
 */
