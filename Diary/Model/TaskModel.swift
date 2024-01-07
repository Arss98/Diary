//
//  TaskModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 02.01.2024.
//
import Foundation
import RealmSwift

class TaskModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var date_start: String = ""
    @objc dynamic var date_finish: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var descriptionTask: String = ""
}
