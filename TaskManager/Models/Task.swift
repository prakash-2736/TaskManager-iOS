//
//  Task.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import Foundation

enum TaskPriority: Int, CaseIterable {
    case p0 = 0
    case p1 = 1
    case p2 = 2

    var title: String {
        switch self {
        case .p0:
            return "High"
        case .p1:
            return "Medium"
        case .p2:
            return "Low"
        }
    }
}

struct Task: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date?
    var isCompleted: Bool
    var priority: TaskPriority
    var imageData: Data?

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        priority: TaskPriority = .p2,
        imageData: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.imageData = imageData
    }
}
