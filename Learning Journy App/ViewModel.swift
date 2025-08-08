

import SwiftUI
import Foundation
import Combine

class ViewModel: ObservableObject {
 
    @Published var duration: String = "Month"

    @Published var streakCount = 0
    @Published var freezeCount = 0
    @Published var maxFreezesPerMonth = 6
    @Published var dayLogged = false
    @Published var dayFrozen = false
    @Published var date = Date()
    @Published var dateStatuses: [Date: String] = [:]
    @Published var days: [Date] = []


    @Published var learningGoal: String = "Swift"
    @Published var selectedDuration: String = "Month"

    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    init() {
        updateCalendarDays()
    }

    func setDuration(forGreetPage duration: String) {
        self.duration = duration
    }


    func updateCalendarDays() {
        days = calendarDisplayDays
    }
    
    func changeWeek(by value: Int) {
        date = Calendar.current.date(byAdding: .weekOfYear, value: value, to: date) ?? date
        updateCalendarDays()
    }

    func toggleLogDay() {
        guard !dayFrozen else { return }
        withAnimation {
            dayLogged.toggle()
            streakCount += dayLogged ? 1 : -1
        }
    }
    
    func toggleFreezeDay() {
        withAnimation {
            if dayFrozen {
                freezeCount -= 1
            } else if freezeCount < maxFreezesPerMonth {
                freezeCount += 1
            }
            dayFrozen.toggle()
        }
    }

    func refreshAll() {
        updateCalendarDays()

        let today = Calendar.current.startOfDay(for: Date())
        streakCount = dateStatuses.values.filter { $0 == "learned" }.count
        freezeCount = dateStatuses.values.filter { $0 == "frozen" }.count

        let todayStatus = dateStatuses[today] ?? "none"
        dayLogged = todayStatus == "learned"
        dayFrozen = todayStatus == "frozen"
    }

    func setLearningGoal(_ goal: String) {
        self.learningGoal = goal
    }
    
    func setDuration(forUpdatePage duration: String) {
        self.selectedDuration = duration
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        return formatter.string(from: date)
    }


    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: date)?.start ?? Date()
    }
    
    var endOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: date)?.end ?? Date()
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: date) ?? Date()
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var sundayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        return Calendar.current.date(byAdding: .day, value: -startOfMonthWeekday, to: startOfMonth) ?? Date()
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        
        // Current month days
        for dayOffset in 0..<numberOfDaysInMonth {
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth) {
                days.append(newDay)
            }
        }
        
        // Previous month days
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth) {
                days.append(newDay)
            }
        }
        
        return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth }.sorted(by: <)
    }
    
    var monthIn: Int {
        Calendar.current.component(.month, from: date)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: date)
    }

    // Static properties for week and month names
    static var capitalizedFirstThreeLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        return weekdays.map { $0.prefix(3).uppercased() }
    }
    
    static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMMM"
        return (1...12).compactMap { month in
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }
    func getDateForDay(_ index: Int) -> Date {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        return calendar.date(byAdding: .day, value: index, to: weekStart) ?? Date()
    }
}
extension Date {
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }

    var endOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.end
    }

    var numberOfDaysInMonth: Int {
        Calendar.current.range(of: .day, in: .month, for: self)!.count
    }
}


