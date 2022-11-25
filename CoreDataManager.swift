//
//  CoreDataManager.swift
//  NYTest
//
//  Created by Ludvig Krantzén on 2022-11-23.
//
// 49:19 Core Data Relationships, predicatates...

import Foundation
import CoreData
import SwiftUI

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "NYTest")
        persistentContainer.loadPersistentStores { description, error  in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
}


class CoreDataManagers {
    static let instance = CoreDataManagers()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "NYTest")
        container.loadPersistentStores { (descrption, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("saved")
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
}

class CoreDataRelationshipViewModel: ObservableObject {
    
    let manager = CoreDataManagers.instance
    @Published var categories: [Category] = []
    @Published var taskObjects: [TaskObject] = []
    @Published var tasks: [Task] = []
    
    init() {
        getCategories()
        getTaskObjects()
        getTasks()
    }
    
    func getCategories() {
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            categories = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getTaskObjects() {
        let request = NSFetchRequest<TaskObject>(entityName: "TaskObject")
        
        do {
            taskObjects = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func getTasks() {
        let request = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            tasks = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func addCategory() {
        let newCategory = Category(context: manager.context)
        newCategory.name = "Daily"
        save()
    }
    
    func addTaskObject() {
        let newTaskObject = TaskObject(context: manager.context)
        newTaskObject.taskType = "Fitness"
        newTaskObject.categories = [categories[0]]
        save()
    }
    
    func addTask() {
        let newTask = Task(context: manager.context)
        newTask.title = "Test title"
        newTask.isComplete = false
        newTask.dateCreated = Date()
        newTask.frequency = "Daily"
        
        newTask.oneObject = taskObjects[0]
        newTask.subObjects = taskObjects[0]
        save()
    }
    
    func save() {
        categories.removeAll()
        taskObjects.removeAll()
        tasks.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.save()
            self.getCategories()
            self.getTaskObjects()
            self.getTasks()
        }
    }
}
struct CoreDataRelationships: View {
    
    @StateObject var vm = CoreDataRelationshipViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Button(action: {
                        vm.addTask()
                    }, label: {
                        Text("Button")
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                    })
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.categories) { category in
                                CategoryView(entity: category)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.taskObjects) { object in
                                TaskObjectView(entity: object)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.tasks) { task in
                                TaskView(entity: task)
                            }
                        }
                    })
                }
            }
        }
    }
}

struct CoreDataRelationships_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationships()
    }
}


struct CategoryView: View {
    
    let entity: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            if let taskObjects = entity.manyObjects?.allObjects as? [TaskObject] {
                Text("TaskObjects:")
                    .bold()
                ForEach(taskObjects) { object in
                    Text(object.taskType ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct TaskObjectView: View {
    
    let entity: TaskObject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.taskType ?? "")")
                .bold()
            
            if let categories = entity.categories?.allObjects as? [Category] {
                Text("Categories:")
                    .bold()
                ForEach(categories) { category in
                    Text(category.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct TaskView: View {
    
    let entity: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.title ?? "")")
                .bold()
            
            Text("One object???")
            Text(entity.oneObject?.taskType ?? "")
            
            Text("Sub Objectsss??")
            Text(entity.subObjects?.taskType ?? "")
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
