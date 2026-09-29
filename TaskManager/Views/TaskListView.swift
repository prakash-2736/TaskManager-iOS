//
//  TaskListView.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import SwiftUI

struct TaskListView: View {
    @State private var tasks : [Task]=[]
    @State private var showingAddTask = false
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(tasks) {
                    task in VStack(alignment: .leading, spacing: 4){
                        
                        Text(task.title).font(.headline)
                        
                        
                        Text(task.description).font(.subheadline).foregroundStyle(.secondary)
                    }.padding()
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.background))
                        .listRowSeparator(.hidden)
                }.onDelete{ idx in tasks.remove(atOffsets: idx)}
            }
            .navigationTitle("Tasks")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    
                    Button{
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            .sheet(isPresented: $showingAddTask){
                NavigationStack{
                    AddTaskView{
                        newTask in tasks.append(newTask)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    TaskListView()
}
