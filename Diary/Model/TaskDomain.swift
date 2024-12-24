import Foundation

struct TaskDomain {
    var id: String?
    var title: String
    var descriptionTask: String
    var dateStart: Date
    var dateFinish: Date
}

struct Section {
    let hour: String
    var tasks: [TaskDomain]
}
