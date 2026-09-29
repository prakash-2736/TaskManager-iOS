//
//  TaskListView.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import SwiftUI

struct TaskListView: View {
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false

    var body: some View {
         NavigationStack {
             VStack(spacing: 0) {
                 HStack {
                     Text("Tasks")
                         .font(.title) // Large size without clipping
                         .fontWeight(.bold)
                     
                     Spacer()
                     
                     Button {
                         showingAddTask = true
                     } label: {
                         Image(systemName: "plus")
                             .font(.title2)
                     }
                 }
                 .padding(.horizontal, 16)
                 .padding(.top, 12)
                 .padding(.bottom, 8)
                 
                 // Content View
                 Group {
                     if tasks.isEmpty {
                         emptyStateView
                     } else {
                         taskList
                     }
                 }
             }
             .navigationBarHidden(true)
             .sheet(isPresented: $showingAddTask) {
                 NavigationStack {
                     AddTaskView { newTask in
                         tasks.append(newTask)
                     }
                 }
             }
         }
     }

    // MARK: - Subviews

    private var taskList: some View {
        List {
            ForEach($tasks) { $task in
                taskRow(for: $task)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
            }
            .onDelete { offsets in
                tasks.remove(atOffsets: offsets)
            }
        }
        .listStyle(.plain)
    }

    private func taskRow(for task: Binding<Task>) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Button {
                withAnimation(.spring(duration: 0.25)) {
                    task.wrappedValue.isCompleted.toggle()
                }
            } label: {
                Image(systemName: task.wrappedValue.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.wrappedValue.isCompleted ? Color.green : Color.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 6) {
                Text(task.wrappedValue.title)
                    .font(.headline)
                    .strikethrough(task.wrappedValue.isCompleted, color: .secondary)
                    .foregroundStyle(task.wrappedValue.isCompleted ? Color.secondary : Color.primary)

                if !task.wrappedValue.description.isEmpty {
                    Text(task.wrappedValue.description)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }

                if let dueDate = task.wrappedValue.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        Text(dueDate, format: .dateTime.month().day().hour().minute())
                    }
                    .font(.caption)
                    .foregroundStyle(task.wrappedValue.isCompleted ? Color.secondary : Color.blue)
                    .padding(.top, 2)
                }
            }

            Spacer()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(task.wrappedValue.isCompleted ? Color.green.opacity(0.1) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(task.wrappedValue.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Tasks Yet", systemImage: "checkmark.circle")
        } description: {
            Text("Tap the + button in the top right to add your first task.")
        }
    }
}

#Preview {
    TaskListView()
}
