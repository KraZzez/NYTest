//
//  DataController.swift
//  NYTest
//
//  Created by Ludvig Krantzén on 2022-11-23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "NYTest")
    
    init() {
        container.loadPersistentStores { description, error in 
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
