//
//  CalendarViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/13.
//

import Foundation

final class CalendarViewModel {
    typealias ChangedDateCompletion = () -> Void
    
    enum Action {
        case selectDate(_ date: Date)
        case moveMonth(value: Int)
        case today
        case pushCalendarView
        case popCalendarView
    }
    
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private var changedBaseDateForMonthCompletion: ChangedDateCompletion?
    private var changedBaseDateForWeekCompletion: ChangedDateCompletion?
    private let calendar = Calendar(identifier: .gregorian)
    
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            changedBaseDateForMonthCompletion?()
        }
    }
    
    private var selectedDate: Date {
        didSet {
            days = generateDaysInMonth(for: self.baseDate)
            daysForWeek = generateDaysInWeek(for: self.baseDate)
        }
    }
    
    private(set) var days: [Day] = []
    private(set) var daysForWeek: [Day] = []
    
    private let dateFormatterOnlyD: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private let dateFormatterCalendarTitle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter
    }()
    
    var localizedCalendarTitle: String {
        return dateFormatterCalendarTitle.string(from: baseDate)
    }
    
    init() {
        let baseDate = Date()
        self.baseDate = baseDate
        self.selectedDate = baseDate
        
        days = generateDaysInMonth(for: baseDate)
        daysForWeek = generateDaysInWeek(for: baseDate)
    }
    
    // MARK: - Methods
    func action(_ action: Action) {
        switch action {
        case .selectDate(let date):
            selectedDate = date
        case .moveMonth(let value):
            baseDate = calendar.date(byAdding: .month, value: value, to: baseDate) ?? baseDate
        case .today:
            let components = self.calendar.dateComponents([.year, .month, .day], from: Date())
            let currentDate = self.calendar.date(from: components) ?? Date()
            baseDate = currentDate
            selectedDate = currentDate
        case .pushCalendarView:
            baseDate = selectedDate
        case .popCalendarView:
            baseDate = selectedDate
            daysForWeek = generateDaysInWeek(for: selectedDate)
            changedBaseDateForWeekCompletion?()
        }
    }
    
    func configureChangedBaseDateForMonthCompletion(_ completion: @escaping ChangedDateCompletion) {
        changedBaseDateForMonthCompletion = completion
    }
    
    func configureChangedBaseDateForWeekCompletion(_ completion: @escaping ChangedDateCompletion) {
        changedBaseDateForWeekCompletion = completion
    }
    
    // MARK: - Generating a Month’s Metadata
    
    private func monthMetadata(for baseDate: Date) -> MonthMetadata? {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            return nil
        }
        
        let firstDayWeekday: Int = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        return Day(
            date: date,
            number: dateFormatterOnlyD.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth)
    }
    
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfDisplayedMonth) else {
            return []
        }
        
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
            }
        return days
    }
    
    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
                
                return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        return days
    }
    // MARK: - Generating a Week’s Metadata
    
    private func weekMatadata(for baseDate: Date) -> WeekMetadata? {
        guard
            let rangeOfDaysInWeek = calendar.range(of: .day, in: .weekOfMonth, for: baseDate),
            let lastDayOfBasedWeek = rangeOfDaysInWeek.last,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            return nil
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let numberOfDaysInWeek = rangeOfDaysInWeek.count
        
        let week: WeekMetadata.Week
        if lastDayOfBasedWeek < 7 {
            week = .first(firstDayWeekday: firstDayWeekday)
        } else if numberOfDaysInWeek < 7 {
            week = .last
        } else {
            week = .normal
        }
        
        return WeekMetadata(week: week, firstDay: firstDayOfMonth, rangeOfDays: rangeOfDaysInWeek)
    }
    
    private func generateDaysInWeek(for baseDate: Date) -> [Day] {
        guard let metadata = weekMatadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day]
        switch metadata.week {
        case .first(let firstDayWeekday):
            days = (1...7).map { day in
                let isWithinDisplayedMonth = day >= firstDayWeekday
                let dayOffset = isWithinDisplayedMonth ? day - firstDayWeekday : -(firstDayWeekday - day)
                
                return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        case .normal:
            days = metadata.rangeOfDays.map { day in
                return generateDay(offsetBy: day - 1, for: firstDayOfMonth, isWithinDisplayedMonth: true)
            }
        case .last:
            days = metadata.rangeOfDays.map { day in
                return generateDay(offsetBy: day - 1, for: firstDayOfMonth, isWithinDisplayedMonth: true)
            }
            days += generateStartOfNextMonth(using: firstDayOfMonth)
        }
        
        return days
    }
}
