//
//  TaskModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 02.01.2024.
//
import Foundation
import RealmSwift

class TaskModel: Object {
    @Persisted(primaryKey: true) var _id = UUID().uuidString
    @Persisted var date_start: Date = Date()
    @Persisted var date_finish: Date = Date()
    @Persisted var name: String = ""
    @Persisted var descriptionTask: String = ""
}
