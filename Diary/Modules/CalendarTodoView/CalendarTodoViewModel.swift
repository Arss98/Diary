//
//  CalendarTodoViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 01.01.2024.
//

import RealmSwift
import Foundation

final class CalendarTodoViewModel {
    private var realm: Realm?
    
    var output: Output
    weak var delegate: CalendarTodoViewModelDelegate?
    
    init() {
        self.output = Output()
        
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
        
        let tasksForDate = realm.objects(TaskModel.self).filter("date_start >= %@ AND date_start <= %@", date.startOfDay, date.endOfDay)
        return !tasksForDate.isEmpty
    }
    
    func deleteTask(_ taskIndex: Int) {
        guard let realm = self.realm else { return }
        
        let task = self.output.taskList[taskIndex]
        
        do {
            try realm.write {
                realm.delete(task)
            }
            self.output.taskList.remove(at: taskIndex)
            delegate?.didChangeItemCount(to: self.output.taskList.count)
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func loadTasks(forDate selectedDate: Date ) {
        guard let realm = self.realm  else { return }
        
        let selectedTasks = realm.objects(TaskModel.self).filter (
            "date_start >= %@ AND date_start <= %@", selectedDate.startOfDay, selectedDate.endOfDay
        ).sorted(byKeyPath: "date_start", ascending: true)
        
        self.output.taskList = Array(selectedTasks)
        
        delegate?.didLoadTasks()
        delegate?.didChangeItemCount(to: self.output.taskList.count)
    }
    
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
}

extension CalendarTodoViewModel {
    struct Output {
        var taskGetCount: Int {
            taskList.count
        }
        var taskList: [TaskModel] = []
    }
}

