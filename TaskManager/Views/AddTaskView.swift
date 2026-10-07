//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import SwiftUI
import PhotosUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss

    let onAddTask: (Task) -> Void

    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var priority: TaskPriority = .p2

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var imageData: Data?

    var body: some View {
        Form {
            Section("Task Details") {
                TextField(
                    "Task Title",
                    text: $title
                )

                TextField(
                    "Description (Optional)",
                    text: $description,
                    axis: .vertical
                )
                .lineLimit(3...6)
            }

            Section("Priority") {
                Picker(
                    "Priority",
                    selection: $priority
                ) {
                    ForEach(
                        TaskPriority.allCases,
                        id: \.self
                    ) { priority in
                        Text(priority.title)
                            .tag(priority)
                    }
                }
            }

            Section("Due Date") {
                Toggle(
                    "Set Due Date",
                    isOn: $hasDueDate.animation()
                )

                if hasDueDate {
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: [
                            .date,
                            .hourAndMinute
                        ]
                    )
                }
            }

            Section("Image") {
                PhotosPicker(
                    selection: $selectedPhotoItem,
                    matching: .images
                ) {
                    Label(
                        imageData == nil
                            ? "Choose Image"
                            : "Change Image",
                        systemImage: "photo"
                    )
                }

                if let imageData,
                   let uiImage = UIImage(data: imageData) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                        )
                }
            }
        }
        .navigationTitle("Add Task")
        .navigationBarTitleDisplayMode(.inline)

        .toolbar {
            ToolbarItem(
                placement: .cancellationAction
            ) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(
                placement: .confirmationAction
            ) {
                Button("Add") {
                    addTask()
                }
                .bold()
                .disabled(
                    title
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
            }
        }

        .task(id: selectedPhotoItem) {
            guard let selectedPhotoItem else {
                return
            }

            do {
                imageData = try await selectedPhotoItem
                    .loadTransferable(type: Data.self)
            } catch {
                imageData = nil
            }
        }
    }

    private func addTask() {
        let trimmedTitle = title
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !trimmedTitle.isEmpty else {
            return
        }

        let trimmedDescription = description
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let newTask = Task(
            title: trimmedTitle,
            description: trimmedDescription,
            dueDate: hasDueDate
                ? dueDate
                : nil,
            priority: priority,
            imageData: imageData
        )

        onAddTask(newTask)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddTaskView { task in
            print(task.title)
        }
    }
}
