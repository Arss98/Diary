import Foundation

final class TaskModelMapper {
    static func matToDomain(from taskEntity: TaskEntity) -> TaskDomain {
        return TaskDomain(
            id: taskEntity.id,
            title: taskEntity.title,
            descriptionTask: taskEntity.descriptionTask,
            dateStart: taskEntity.dateStart,
            dateFinish: taskEntity.dateFinish)
    }
    
    static func mapToEntity(from task: TaskDomain) -> TaskEntity {
        let taskEntity = TaskEntity()
        
        if let taskId = task.id, !taskId.isEmpty {
            taskEntity.id = taskId
        }
        
        taskEntity.dateStart = task.dateStart
        taskEntity.dateFinish = task.dateFinish
        taskEntity.title = task.title
        taskEntity.descriptionTask = task.descriptionTask
        return taskEntity
    }
}

// MARK: - List Mapper
extension TaskModelMapper {
    static func matToDomainList(from taskEntitys: [TaskEntity]) -> [TaskDomain] {
        return taskEntitys.map { matToDomain(from: $0) }
    }
    
    static func mapToEntityList(from tasks: [TaskDomain]) -> [TaskEntity] {
        return tasks.map { mapToEntity(from: $0) }
    }
}
