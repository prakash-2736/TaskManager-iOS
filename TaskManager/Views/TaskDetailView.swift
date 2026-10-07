//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 02/10/26.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Binding var task: Task
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header Card
                HStack(alignment: .top, spacing: 14) {
                    
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            task.isCompleted.toggle()
                        }
                    } label: {
                        Image(
                            systemName: task.isCompleted
                                ? "checkmark.circle.fill"
                                : "circle"
                        )
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(
                            task.isCompleted
                                ? Color.green
                                : Color.secondary
                        )
                    }
                    .buttonStyle(.plain)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(task.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .strikethrough(
                                task.isCompleted,
                                color: .secondary
                            )
                            .foregroundStyle(
                                task.isCompleted
                                    ? Color.secondary
                                    : Color.primary
                            )
                        
                        Text(
                            task.isCompleted
                                ? "Completed"
                                : "In Progress"
                        )
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            task.isCompleted
                                ? Color.green
                                : Color.orange
                        )
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(
                                    task.isCompleted
                                        ? Color.green.opacity(0.15)
                                        : Color.orange.opacity(0.15)
                                )
                        )
                    }
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            Color(.secondarySystemGroupedBackground)
                        )
                )
                
                // Info Badges (Priority & Due Date)
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Details")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        
                        // Priority Badge
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Priority")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(
                                        priorityColor(
                                            for: task.priority
                                        )
                                    )
                                    .frame(width: 8, height: 8)
                                
                                Text(task.priority.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    Color(
                                        .secondarySystemGroupedBackground
                                    )
                                )
                        )
                        
                        // Due Date Badge
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Due Date")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if let dueDate = task.dueDate {
                                HStack(spacing: 6) {
                                    Image(systemName: "calendar")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                    
                                    Text(
                                        dueDate,
                                        format: .dateTime
                                            .month()
                                            .day()
                                            .hour()
                                            .minute()
                                    )
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                }
                            } else {
                                Text("No Due Date")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    Color(
                                        .secondarySystemGroupedBackground
                                    )
                                )
                        )
                    }
                }
                
                // Description Card
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading) {
                        
                        if task.description
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty {
                            
                            Text("No description provided.")
                                .font(.body)
                                .italic()
                                .foregroundStyle(.secondary)
                            
                        } else {
                            
                            Text(task.description)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                Color(
                                    .secondarySystemGroupedBackground
                                )
                            )
                    )
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
    
    private func priorityColor(
        for priority: TaskPriority
    ) -> Color {
        switch priority {
        case .p0:
            return .red
            
        case .p1:
            return .orange
            
        case .p2:
            return .blue
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(
            task: .constant(
                Task(
                    title: "Sample Task",
                    description: "This is a detailed task description.",
                    dueDate: Date(),
                    priority: .p0
                )
            )
        )
    }
}
