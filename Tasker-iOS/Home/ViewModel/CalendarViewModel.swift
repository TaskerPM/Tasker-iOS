//
//  CalendarViewModel.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/13.
//

import Foundation

struct Day {
    /// Date 인스턴스.
    let date: Date
    
    /// 화면에 표시될 숫자.
    /// 예) Date 인스턴스가 2022년 1월 25일이라면 -> 25
    let number: String
    
    /// 이 날짜가 선택되었는지 여부.
    let isSelected: Bool
    
    /// 이 날짜가 현재 달 내에 있는지 추적.
    /// 예) 1월 달력을 그리고자 할 떄 Date 인스턴스가 1월 25일이라면 true, 2월 1일이라면 false
    let isWithinDisplayedMonth: Bool
}

struct MonthMetadata {
    /// 해당 달의 총 일수, 예를 들어 1월은 31일까지 있으므로 31
    let numberOfDays: Int
    
    /// 해당 달의 첫 Date
    let firstDay: Date
    
    /// 해당 달의 첫 Date가 무슨 요일인지 반환, 일 ~ 토 => 1 ~ 7
    /// 예) 수요일이라면 4
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

enum CalendarDataError: Error {
    case metadataGeneration
}

protocol CalendarViewModelDelegate: AnyObject {
    func popedCalendar()
    func movedMonth()
}

final class CalendarViewModel {
//    typealias DateHandler = (Date) -> Void
    
    enum Action {
        case selectDate(_ date: Date)
        case moveMonth(value: Int)
        case today
        case popCalendar
    }
    
    //    private let changedBaseDateHandler: DateHandler
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendar = Calendar(identifier: .gregorian)
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
        }
    }
    
    private var selectedDate: Date {
        didSet {
            days = generateDaysInMonth(for: self.baseDate)
        }
    }
    private(set) var days: [Day] = []
    private(set) var daysForWeek: [Day] = []
    private weak var delegate: CalendarViewModelDelegate?
    
    /// baseDate가 속한 달에서 주(week)의 수는 몇개인지 반환
    var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
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
    
    init(baseDate: Date = Date(), delegate: CalendarViewModelDelegate) {
        self.baseDate = baseDate
        self.delegate = delegate
//        self.changedBaseDateHandler = changedBaseDateHandler
        self.selectedDate = baseDate
        days = generateDaysInMonth(for: self.baseDate)
        daysForWeek = generateDaysInWeek(for: self.baseDate)
    }
    
    // MARK: - Methods
    func action(_ action: Action) {
        switch action {
        case .selectDate(let date):
            selectedDate = date
        case .moveMonth(let value):
            baseDate = calendar.date(byAdding: .month, value: value, to: baseDate) ?? baseDate
            delegate?.movedMonth()
        case .today:
            let components = self.calendar.dateComponents([.year, .month, .day], from: Date())
            let currentDate = self.calendar.date(from: components) ?? Date()
            baseDate = currentDate
            selectedDate = currentDate
            delegate?.movedMonth()
        case .popCalendar:
            daysForWeek = generateDaysInWeek(for: selectedDate)
            delegate?.popedCalendar()
        }
    }
    
    // MARK: - Generating a Month’s Metadata
    
    ///  Date를 기준으로 월별 메타데이터인 MonthMetaData 인스턴스를 생성.
    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        // You ask the calendar for the number of days in baseDate‘s month, then you get the first day of that month.
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            // Both of the previous calls return optional values. If either returns nil, the code throws an error and returns.
            throw CalendarDataError.metadataGeneration
        }
        // You get the weekday value, a number between one and seven that represents which day of the week the first day of the month falls on.
        // weekday: 주일, 평일: 일요일 이외의 6일간을 가리키는 경우와 토·일요일 이외의 5일간을 가리키는 경우가 있음.
        let firstDayWeekday: Int = calendar.component(.weekday, from: firstDayOfMonth)
        // Finally, you use these values to create an instance of MonthMetadata and return it.
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstDayWeekday: firstDayWeekday)
    }
    
    /// Adds or subtracts an offset from a Date to produce a new one, and return its result.
    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        return Day(
            date: date,
            number: dateFormatterOnlyD.string(from: date),
            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
            isWithinDisplayedMonth: isWithinDisplayedMonth)
    }
    
    /// Takes the first day of the displayed month and returns an array of Day objects.
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        // Retrieve the last day of the displayed month. If this fails, you return an empty array.
        guard let lastDayInMonth = calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfDisplayedMonth) else {
            return []
        }
        // Calculate the number of extra days you need to fill the last row of the calendar.
        // For instance, if the last day of the month is a Saturday, the result is zero and you return an empty array.
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
        guard additionalDays > 0 else {
            return []
        }
        /*
         Create a Range<Int> from one to the value of additionalDays, as in the previous section.
         Then, it transforms this into an array of Days.
         This time, generateDay(offsetBy:for:isWithinDisplayedMonth:) adds the current day in the loop to lastDayInMonth
         to generate the days at the beginning of the next month.
         */
        let days: [Day] = (1...additionalDays)
            .map {
                generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
            }
        return days
    }
    
    /// Takes in a Date and returns an array of Days.
    private func generateDaysInMonth(for baseDate: Date) -> [Day] {
        // Retrieve the metadata you need about the month, using monthMetadata(for:).
        // If something goes wrong here, the app can’t function. As a result, it terminates with a fatalError.
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday
        let firstDayOfMonth = metadata.firstDay
        /*
         If a month starts on a day other than Sunday, you add the last few days from the previous month at the beginning.
         This avoids gaps in a month’s first row. Here, you create a Range<Int> that handles this scenario.
         For example, if a month starts on Friday, offsetInInitialRow would add five extra days to even up the row.
         You then transform this range into [Day], using map(_:).
         */
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                // Check if the current day in the loop is within the current month or part of the previous month.
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                // Calculate the offset that day is from the first day of the month. If day is in the previous month, this value will be negative.
                let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
                // Call generateDay(offsetBy:for:isWithinDisplayedMonth:), which adds or subtracts an offset from a Date to produce a new one, and return its result.
                return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        days += generateStartOfNextMonth(using: firstDayOfMonth)
        return days
    }
    // MARK: - Generating a Week’s Metadata
    
    private func weekMatadata(for baseDate: Date) throws -> WeekMetadata {
        guard
            let rangeOfDaysInWeek = calendar.range(of: .day, in: .weekOfMonth, for: baseDate),
            let lastDayOfBasedWeek = rangeOfDaysInWeek.last,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: baseDate))
        else {
            throw CalendarDataError.metadataGeneration
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
        guard let metadata = try? weekMatadata(for: baseDate) else {
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
                let dayOffset = day - 1
                return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: true)
            }
        case .last:
            days = metadata.rangeOfDays.map { day in
                let dayOffset = day - 1
                return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: true)
            }
            days += generateStartOfNextMonth(using: firstDayOfMonth)
        }
        
        return days
    }
}
