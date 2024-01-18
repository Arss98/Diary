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
    var taskList: Results<TaskModel>!
    weak var delegate: CalendarTodoViewModelDelegate?
    
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
        
        let task = taskList[taskIndex]
        
        do {
            try realm.write {
                realm.delete(task)
            }
            delegate?.didChangeItemCount(to: taskList.count)
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func loadTasks(forDate selectedDate: Date ) {
        guard let realm = self.realm  else { return }
        
        taskList = realm.objects(TaskModel.self).filter(
            "dateStart >= %@ AND dateStart <= %@", selectedDate.startOfDay, selectedDate.endOfDay
        ).sorted(byKeyPath: "dateStart", ascending: true)
                
        delegate?.didLoadTasks()
        delegate?.didChangeItemCount(to: taskList.count)
    }
    
    func configureCell(_ cell: CustomTableViewCell, indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        cell.configure(from: dateToString(task.dateStart), to: dateToString(task.dateFinish), nameTask: task.name)
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
