import Foundation
import RealmSwift

class TaskEntity: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var descriptionTask: String = ""
    @Persisted var dateStart: Date = Date()
    @Persisted var dateFinish: Date = Date()
}
