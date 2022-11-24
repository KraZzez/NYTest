//
//  ShowTasks.swift
//  NYTest
//
//  Created by Ludvig Krantzén on 2022-11-24.
//

import SwiftUI

struct ShowTasks: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTasks: FetchedResults<Task>
    
    @State private var showDaily: Bool = false
    @State private var showWeekly: Bool = false
    @State private var showMonthly: Bool = false
    
    let contentView = ContentView()
    
    var body: some View {
        VStack {
            
            Button {
                showDaily.toggle()
            } label: {
                Image(systemName: "chevron.right")
                Text("Today's tasks")
            }
            

            ForEach(allTasks) { task in
                if task.frequency == "Daily" && showDaily {
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
                }
            }.onDelete(perform: deleteTask)
            
            Button {
                showWeekly.toggle()
            } label: {
                Image(systemName: "chevron.right")
                Text("Today's tasks")
            }
            
            ForEach(allTasks) { task in
                if task.frequency == "Weekly" && showWeekly {
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
                }
            }.onDelete(perform: deleteTask)
            
            Button {
                showMonthly.toggle()
            } label: {
                Image(systemName: "chevron.right")
                Text("Today's tasks")
            }
            
            ForEach(allTasks) { task in
                if task.frequency == "Monthly" && showMonthly {
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
                }
            }.onDelete(perform: deleteTask)
            
        }
    }
}

struct ShowTasks_Previews: PreviewProvider {
    static var previews: some View {
        ShowTasks()
    }
}


extension ShowTasks {
    
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
    
    private func updateTask(_ task: Task) {
        task.isComplete = !task.isComplete
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForFrequency(_ value: String) -> Color {
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
}
