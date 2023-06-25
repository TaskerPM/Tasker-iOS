//
//  TaskModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/13.
//

import Foundation

struct TaskListModel {
    var title: String
    var startTime: String
    var endTime: String
    var category: Category
    var isCompleted: Bool
}

struct Category {
    var categoryName: String
    var categoryColor: CategoryColor
}

struct CategoryColor {
    var backgroundColor: String
    var textColor: String
}
