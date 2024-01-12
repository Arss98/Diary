//
//  CalendarTodoViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 01.01.2024.
//

import RealmSwift
import Foundation

protocol CalendarTodoViewModelDelegate: AnyObject {
    func didLoadTasks()
    func didChangeItemCount(to count: Int)
}

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
    
    func deleteTask(_ taskIndex: Int) {
        let task = self.output.taskList[taskIndex]
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(task)
            }
        } catch {
            // Обработка ошибок
        }
        self.output.taskList.remove(at: taskIndex)
        delegate?.didChangeItemCount(to: self.output.taskList.count)
    }
    
    func loadTasks() {
        do {
            let realm = try Realm()
            let tasks = realm.objects(TaskModel.self)
            self.output.taskList = Array(tasks)
            
            delegate?.didLoadTasks()
            delegate?.didChangeItemCount(to: self.output.taskList.count)
        } catch {
            print("Error load date")
        }
    }
    
}

extension CalendarTodoViewModel {
    struct Output {
        var taskGetCount: Int {
            return taskList.count
        }
        
        var taskList: [TaskModel] = []
    }
}

