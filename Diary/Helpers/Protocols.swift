//
//  Protocols.swift
//  Diary
//
//  Created by  Arsen Dadaev on 13.01.2024.
//

import Foundation

protocol CalendarTodoViewModelDelegate: AnyObject {
    func didLoadTasks()
    func didChangeItemCount(to count: Int)
}
