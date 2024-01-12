//
//  AddTaskViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 09.01.2024.
//

import Foundation
import RealmSwift

final class AddTaskViewModel {
    func validateInput(title: String?, description: String?) -> (title: String, description: String)? {
        guard let title = title, let description = description else { return nil }
        
        return (title, description)
    }
    
    func saveData(title: String, description: String, dateStart: Date, dateFinish: Date) {
        do {
            let realm = try Realm()
            
            try realm.write {
                let task = TaskModel()
                task.date_start = dateStart
                task.date_finish = dateFinish
                task.name = title
                task.descriptionTask = description
                realm.add(task)
            }
            
            print("Data saved to Realm")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}


