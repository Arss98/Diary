//
//  CalendarTodoViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 01.01.2024.
//

import RealmSwift
import Foundation

final class CalendarTodoViewModel {
    private let dateFormatter = DateFormatter()
    private var realm: Realm?
    weak var delegate: CalendarTodoViewModelDelegate?
    var taskList: Results<TaskModel>?
    var taskDictionary: [Int: TaskModel] = [:]
    var currentDate: String {
        return getCurrentDate()
    }
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Error creating Realm instance: \(error.localizedDescription)")
        }
    }
}

extension CalendarTodoViewModel {
    func checkTaskOfDay(date: Date) -> Bool {
        guard let realm = self.realm else { return false}
        
        let tasksForDate = realm.objects(TaskModel.self).filter("dateStart >= %@ AND dateStart <= %@", date.startOfDay, date.endOfDay)
        return !tasksForDate.isEmpty
    }
    
    func deleteTask(_ taskIndex: Int) {
        guard let realm = self.realm else { return }
        
        if let task = taskList?[taskIndex] {
            do {
                try realm.write {
                    realm.delete(task)
                }
                
                taskDictionary.removeValue(forKey: taskIndex)
                delegate?.didChangeItemCount(to: taskList?.count ?? 0)
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }
    
    func loadTasks(forDate selectedDate: Date ) {
        clearTaskDictionary()
        
        guard let realm = self.realm  else { return }
        
        taskList = realm.objects(TaskModel.self).filter(
            "dateStart >= %@ AND dateStart <= %@", selectedDate.startOfDay, selectedDate.endOfDay
        ).sorted(byKeyPath: "dateStart", ascending: true)
        
        delegate?.didLoadTasks()
        delegate?.didChangeItemCount(to: taskList?.count ?? 0)
    }
    
    func configureCompactCell(_ cell: CompactCustomTableViewCell, indexPath: IndexPath) {
        if let task = taskList?[indexPath.row] {
            cell.configure(from: dateToString(task.dateStart), to: dateToString(task.dateFinish), nameTask: task.name)
        }
    }
    
    func configureExpandetCell(_ cell: ExpandedCustomTableViewCell, indexPath: IndexPath, date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        let hour = indexPath.row % 24
        let timeInterval = TimeInterval(hour * 60 * 60)
        let startTime = startOfDay.addingTimeInterval(timeInterval)
        let endTime = startOfDay.addingTimeInterval(timeInterval + (60 * 60))
        
        if let task = taskList?.first(where: { $0.dateStart >= startTime && $0.dateStart < endTime }) {
            taskDictionary[indexPath.row] = task
            cell.configure(startTime: dateToString(startTime), title: task.name)
        } else {
            cell.configure(startTime: dateToString(startTime))
        }
    }
}

// MARK: - Private metods
private extension CalendarTodoViewModel {
    func clearTaskDictionary() {
        taskDictionary.removeAll()
    }
    
    func getCurrentDate() -> String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
    
    func dateToString(_ date: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
