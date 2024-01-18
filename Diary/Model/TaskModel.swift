//
//  TaskModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 02.01.2024.
//
import Foundation
import RealmSwift

class TaskModel: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var dateStart: Date = Date()
    @Persisted var dateFinish: Date = Date()
    @Persisted var name: String = ""
    @Persisted var descriptionTask: String = ""
}
