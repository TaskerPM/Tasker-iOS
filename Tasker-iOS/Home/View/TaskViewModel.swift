//
//  TaskViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/13.
//

import Foundation

final class TaskViewModel {
    private var tasks: [TaskListModel] = [
        TaskListModel(title: "", startTime: "", endTime: "", category: Category(categoryName: "", categoryColor: CategoryColor(backgroundColor: "", textColor: "")), isCompleted: false)
    ]
    
    var itemCount: Int {
        return tasks.count
    }
    
    func item(at index: Int) -> TaskListModel {
            return tasks[index]
        }
    
    func addItem(_ newItem: TaskListModel) {
        tasks.append(newItem)
    }
    
    func deleteItem(at index: Int) {
        tasks.remove(at: index)
    }
    
    func updateItem(at index: Int, with newText: String) {
        tasks[index].title = newText
    }
    
    func toggleItemCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
    }
}
