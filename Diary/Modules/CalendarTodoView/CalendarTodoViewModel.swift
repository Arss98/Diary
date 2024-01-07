//
//  CalendarTodoViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 01.01.2024.
//

import FSCalendar
import RealmSwift

final class CalendarTodoViewModel: NSObject {
    let realm = try! Realm()
    let input: Input
    var output: Output
    
    override init() {
        self.input = Input()
        self.output = Output()
    }
}

extension CalendarTodoViewModel {
    func configureCell(_ cell: CustomTableViewCell, indexPath: IndexPath) {
        let task = output.taskList[indexPath.row]
        cell.configure(from: task.date_start, to: task.date_finish, nameTask: task.name)
    }
    
    
}

extension CalendarTodoViewModel {
    struct Input {
        
    }
    
    struct Output {
        var taskGetCount: Int {
            return taskList.count
        }
        
        let taskList: [TaskModel] = []
    }
}

