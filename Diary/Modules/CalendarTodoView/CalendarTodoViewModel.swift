//
//  CalendarTodoViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 01.01.2024.
//

import RealmSwift
import Foundation

final class CalendarTodoViewModel {
    var output: Output
    weak var delegate: CalendarTodoViewModelDelegate?
    
    init() {
        self.output = Output()
    }
}

extension CalendarTodoViewModel {
    func configureCell(_ cell: CustomTableViewCell, indexPath: IndexPath) {
        let task = output.taskList[indexPath.row]
        
        cell.configure(from: dateToString(task.date_start), to: dateToString(task.date_finish), nameTask: task.name)
    }
    
    func getCurrentDate() -> String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "MMMM yyyy"
        return dateFormator.string(from: Date())
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func checkTaskOfDay(date: Date) -> Bool {
        do {
            let realm = try Realm()
            let tasksForDate = realm.objects(TaskModel.self).filter("date_start >= %@ AND date_start <= %@", date.startOfDay, date.endOfDay)
            return !tasksForDate.isEmpty
        } catch {
            return false
        }
    }
    
    func deleteTask(_ taskIndex: Int) {
        let task = self.output.taskList[taskIndex]
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Error deleting task")
        }
        self.output.taskList.remove(at: taskIndex)
        delegate?.didChangeItemCount(to: self.output.taskList.count)
    }
    
    func loadTasks(forDate selectedDate: Date ) {
        do {
            let realm = try Realm()
            let selectedTasks = realm.objects(TaskModel.self).filter (
                "date_start >= %@ AND date_finish <= %@", selectedDate.startOfDay, selectedDate.endOfDay
            ).sorted(byKeyPath: "date_start", ascending: true)
            
            self.output.taskList = Array(selectedTasks)
            
            delegate?.didLoadTasks()
            delegate?.didChangeItemCount(to: self.output.taskList.count)
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
}

extension CalendarTodoViewModel {
    struct Output {
        var taskGetCount: Int {
            taskList.count
        }
        var taskList: [TaskModel] = []
    }
}

