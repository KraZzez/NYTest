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
  /*
    func styleForFrequency(_ value: String) -> Color {
        let frequency = Frequency(rawValue: value)
        
        switch frequency {
        case .daily:
            return Color.green
        case .weekly:
            return Color.yellow
        case .monthly:
            return Color.red
        default:
            return Color.black
        }
    }
    
    func updateTask(_ task: Task) {
        task.isComplete = !task.isComplete
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offset: IndexSet) {
        offset.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
   */
    
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
                NavigationLink {
                    ShowTasks()
                } label: {
                    Text("Test")
                }/*
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Rectangle()
                                .fill(styleForFrequency(task.frequency!))
                                .frame(width: 5, height: 20)
                            Image(systemName: task.isComplete ? "checkmark.circle" : "circle")
                                .onTapGesture {
                                    updateTask(task)
                                }
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                        }
                    }.onDelete(perform: deleteTask)
                }*/
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
