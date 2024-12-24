import Foundation
import RealmSwift

protocol RepositoryProtocol {
    func save(task: TaskEntity) throws
    func delete(by id: String) throws
    func deleteAll() throws
    func fetchTask(by id: String) throws -> TaskEntity
    func fetchAll(forDate date: Date) -> [TaskEntity]
    func update(task: TaskEntity) throws
}

enum TaskError: Error {
    case notFound
    case failedToInitializeRealm(Error)
    case transactionFailed(Error)
}

final class RealmRepository: RepositoryProtocol {
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Error creating Realm instance: \(error.localizedDescription)")
        }
    }
}

// MARK: - RealmRepositoryProtocol
extension RealmRepository {
    func save(task: TaskEntity) throws {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            throw TaskError.transactionFailed(error)
        }
    }
    
    func delete(by id: String) throws {
        do {
            guard let taskToDelete = realm.objects(TaskEntity.self).filter("id == %@", id).first else {
                throw TaskError.notFound
            }
            try realm.write {
                realm.delete(taskToDelete)
            }
        } catch {
            throw TaskError.transactionFailed(error)
        }
    }
    
    func deleteAll() throws {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            throw TaskError.transactionFailed(error)
        }
    }
    
    func fetchTask(by id: String) throws -> TaskEntity {
        guard let task = realm.objects(TaskEntity.self).filter("id == %@", id).first else {
            throw TaskError.notFound
        }
        return task
    }
    
    func fetchAll(forDate date: Date) -> [TaskEntity] {
        let results = realm.objects(TaskEntity.self).filter(
            "dateStart >= %@ AND dateStart <= %@", date.startOfDay, date.endOfDay
        ).sorted(byKeyPath: "dateStart", ascending: true)
        
        return Array(results)
    }
    
    func update(task: TaskEntity) throws {
        do {
            guard let taskToUpdate = realm.objects(TaskEntity.self).filter("id == %@", task.id).first else {
                throw TaskError.notFound
            }
            try realm.write {
                taskToUpdate.title = task.title
                taskToUpdate.descriptionTask = task.descriptionTask
                taskToUpdate.dateStart = task.dateStart
                taskToUpdate.dateFinish = task.dateFinish
            }
        } catch {
            throw TaskError.transactionFailed(error)
        }
    }
}
