import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        let startOfNextDay = Calendar.current.date(byAdding: .day, value: 1, to: self.startOfDay)!
        return startOfNextDay.addingTimeInterval(-1)
    }
    
    var dateToString: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
