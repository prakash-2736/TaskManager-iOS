//
//  Task.swift
//  TaskManager
//
//  Created by Indukuri Sailaj Prakash on 29/09/26.
//

import Foundation

struct Task:Identifiable {
    let id: UUID
    var title: String
    var description : String
    
    
    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
