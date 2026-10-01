import SwiftUI

struct TaskListView: View {
    
    @State private var tasks: [Task] = []
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack {
                    Text("Tasks")
                        .font(.title)
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
            ForEach(sortedTasks) { task in
                taskRow(for: task)
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(
                            top: 6,
                            leading: 16,
                            bottom: 6,
                            trailing: 16
                        )
                    )
                    .listRowBackground(Color.clear)
            }
            .onDelete { offsets in
                deleteTasks(at: offsets)
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - Sorted Tasks
    
    private var sortedTasks: [Task] {
        tasks.sorted {
            
            // Rule 1: Priority comes first
            if $0.priority.rawValue != $1.priority.rawValue {
                return $0.priority.rawValue < $1.priority.rawValue
            }
            
            // Rule 2: Within the same priority,
            // tasks with earlier due dates come first
            switch ($0.dueDate, $1.dueDate) {
                
            case let (date1?, date2?):
                return date1 < date2
                
            case (_?, nil):
                return true
                
            case (nil, _?):
                return false
                
            case (nil, nil):
                return false
            }
        }
    }
    
    // MARK: - Task Row
    
    private func taskRow(for task: Task) -> some View {
        HStack(alignment: .top, spacing: 14) {
            
            Button {
                toggleTaskCompletion(task)
            } label: {
                Image(
                    systemName: task.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title2)
                .foregroundStyle(
                    task.isCompleted
                        ? Color.green
                        : Color.secondary
                )
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(task.priority.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                
                Text(task.title)
                    .font(.headline)
                    .strikethrough(
                        task.isCompleted,
                        color: .secondary
                    )
                    .foregroundStyle(
                        task.isCompleted
                            ? Color.secondary
                            : Color.primary
                    )
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                
                if let dueDate = task.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                        
                        Text(
                            dueDate,
                            format: .dateTime
                                .month()
                                .day()
                                .hour()
                                .minute()
                        )
                    }
                    .font(.caption)
                    .foregroundStyle(
                        task.isCompleted
                            ? Color.secondary
                            : Color.blue
                    )
                    .padding(.top, 2)
                }
            }
            
            Spacer()
        }
        .padding(14)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    task.isCompleted
                        ? Color.green.opacity(0.1)
                        : Color(.systemGray6)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    task.isCompleted
                        ? Color.green.opacity(0.3)
                        : Color.clear,
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Toggle Completion
    
    private func toggleTaskCompletion(_ task: Task) {
        guard let index = tasks.firstIndex(
            where: { $0.id == task.id }
        ) else {
            return
        }
        
        withAnimation(.spring(duration: 0.25)) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    // MARK: - Delete Tasks
    
    private func deleteTasks(at offsets: IndexSet) {
        let idsToDelete = offsets.map {
            sortedTasks[$0].id
        }
        
        tasks.removeAll { task in
            idsToDelete.contains(task.id)
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label(
                "No Tasks Yet",
                systemImage: "checkmark.circle"
            )
        } description: {
            Text(
                "Tap the + button in the top right to add your first task."
            )
        }
    }
}

#Preview {
    TaskListView()
}
