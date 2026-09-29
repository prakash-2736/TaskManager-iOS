//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    let onAddTask: (Task) -> Void
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    
    var body: some View {
        Form{
            
            Section("Task"){
                TextField("Task name ",text:$title)
                
                TextField("Description",text: $description,axis: .vertical)
                }
            
            Section("Due Date"){
                
                DatePicker("Due date" , selection: $dueDate,displayedComponents: [.date,.hourAndMinute])
            }
            
            
            Section{
                Button("Add Task"){
                    addTask()
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        
        .navigationTitle("Add Task")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func addTask(){
        
//        print("Task: \(title)")
//        print("Description: \(description)")
//        print("Due Date: \(dueDate)")
        
        
        let newTask = Task(title: title, description: description)
        onAddTask(newTask)
        dismiss()
    }
}

#Preview {
    NavigationStack{
        AddTaskView{
            task in print(task.title)
        }
    }
}
