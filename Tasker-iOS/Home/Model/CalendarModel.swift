//
//  CalendarModel.swift
//  Tasker-iOS
//
//  Created by Wonbi on 2023/05/17.
//

import Foundation

struct Day {
    let date: Date
    let number: String
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
}

struct WeekMetadata {
    enum Week: Equatable {
        case first(firstDayWeekday: Int)
        case normal
        case last
    }
    
    let week: Week
    let firstDay: Date
    let rangeOfDays: Range<Int>
}
