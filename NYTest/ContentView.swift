//
//  ContentView.swift
//  NYTest
//
//  Created by Ludvig Krantzén on 2022-11-23.
//

import SwiftUI


enum Frequency: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

extension Frequency {
    
    var title: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
}


struct ContentView: View {
    @State private var title: String = ""
    @State private var selectedFrequency: Frequency = .weekly
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTasks: FetchedResults<Task>
    
    private func saveTask() {
        
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.frequency = selectedFrequency.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    var body: some View {
        NavigationStack {
            
            VStack{
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(Frequency.allCases){ frequency in
                        Text(frequency.title).tag(frequency)
                    }
                }.pickerStyle(.segmented)
                
                Button {
                    saveTask()
                } label: {
                    Text("Save")
                }
                
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Circle()
                            Text(task.title ?? "")
                        }
                    }
                }

            }
            .padding()
 
 /*           VStack {
                List(students) { student in
                    Text(student.name ?? "Unknown")
                }
                
                Button("Add"){
                    let firstNames = ["Ginny", "Harry", "First"]
                    let lastNames = ["Granger", "Potter", "Last"]
                    
                    let chosenFirstName = firstNames.randomElement()!
                    let chosenLastName = lastNames.randomElement()!
                    
                    let student = Student(context: moc)
                    student.id = UUID()
                    student.name = "\(chosenFirstName) \(chosenLastName)"
                    
                    try? moc.save()
                }
            } */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
