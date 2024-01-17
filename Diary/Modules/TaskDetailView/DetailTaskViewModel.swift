//
//  TaskDetailViewModel.swift
//  Diary
//
//  Created by  Arsen Dadaev on 15.01.2024.
//

import Foundation
import RealmSwift

final class DetailTaskViewModel {
    var output: Output
    
    init() {
        self.output = Output()
    }
}

extension DetailTaskViewModel {
    func formatDateToString(from startTime: Date, to endTime: Date) -> String {
        let dayOfWeek = DateFormatter()
        dayOfWeek.dateFormat = "EEEE, d MMM yyyy"
        let dayOfWeekString = dayOfWeek.string(from: startTime)
        
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        
        let start = time.string(from: startTime)
        let end = time.string(from: endTime)
        
        return "\(dayOfWeekString)\nfrom \(start) to \(end)"
    }
    
    func loadData(id: String) {
        do {
            let realm = try Realm()
            
            if let data = realm.objects(TaskModel.self).filter("_id == %@", id).first {
                self.output.date = data.date_start
                self.output.title = data.name
                self.output.description = data.descriptionTask
                self.output.timeInterval = formatDateToString(from: data.date_start, to: data.date_finish)
            }
        } catch {
            print("Error loading task: \(error.localizedDescription)")
        }
    }
}

extension DetailTaskViewModel{
    struct Output {
        var date: Date = Date()
        var title: String = ""
        var description: String = ""
        var timeInterval: String = ""
    }
}
