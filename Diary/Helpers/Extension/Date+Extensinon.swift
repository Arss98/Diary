//
//  Date+Extensinon.swift
//  Diary
//
//  Created by  Arsen Dadaev on 13.01.2024.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
        return startOfNextDay.addingTimeInterval(-1)
    }
}
