//
//  AddTaskViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 09.01.2024.
//

import Foundation
import RealmSwift

final class AddTaskViewModel {
    private var realm: Realm?
    
    init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Error creating Realm instance: \(error.localizedDescription)")
        }
    }
  
    func deleteTask(id: String) {
        guard let realm = self.realm else { return }
        
        do {
            if let taskToDelete = realm.objects(TaskModel.self).filter("id == %@", id).first {
                try realm.write {
                    realm.delete(taskToDelete)
                }
            }
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func updateTask(id: String, title: String, description: String, dateStart: Date, dateFinish: Date) {
        guard let realm = self.realm else { return }
        
        do {
            if let taskToUpdate = realm.objects(TaskModel.self).filter("id == %@", id).first {
                try realm.write {
                    taskToUpdate.name = title
                    taskToUpdate.descriptionTask = description
                    taskToUpdate.dateStart = dateStart
                    taskToUpdate.dateFinish = dateFinish
                }
            }
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    func saveTask(title: String, description: String, dateStart: Date, dateFinish: Date) {
        guard let realm = self.realm else { return }
        
        do {
            try realm.write {
                let task = TaskModel()
                task.dateStart = dateStart
                task.dateFinish = dateFinish
                task.name = title
                task.descriptionTask = description
                realm.add(task)
            }
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
    
    func validateInput(title: String?, description: String?) -> (title: String, description: String)? {
        guard let title = title, let description = description else { return nil }
        
        return (title, description)
    }
}
