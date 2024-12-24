import Foundation

struct Consts {
    struct UIConstants {
        static let customCompactCellIdentifier = "CompactCustomTableViewCell"
        static let selectDateAlertTitle = "Select Date"
        static let editTaskTitle = "Edit Event"
        static let saveButtonTitle = "Create task"
        static let startDateTitle = "Starts"
        static let endDateTitle = "Ends"
        static let okButton = "OK"
        static let backButtonTitle = "Back"
        static let editButtonTitle = "Edit"
        static let deleteButtonTitle = "Delete"
        static let cancelButtonTitle = "Cancel"
    }
    
    struct Placeholders {
        static let placeholderNodeText = "Add a description..."
        static let placeholderTaskTitle = "Task title"
    }
    
    struct Headers {
        static let headerTaskDescription = "Description"
        static let headerTaskTitle = "Title"
        static let tableHeaderView = "Schedule"
        static let addTaskTitle = "Create New Task"
        static let editTaskTitle = "Edit Task"
        static let detailTaskTitle = "Task Details"
    }
    
    struct Alerts {
        static let deleteAlertTitle = "Confirmation of deletion"
        static let deleteAlertDescription = "Are you sure you want to delete this task?"
        static let alertErrorTitle = "Error"
    }
    
    struct ErrorMessages {
        static let errorTitle = "The 'Title' field cannot be empty."
        static let errorDescription = "The 'Description' field cannot be empty."
        static let alertErrorMessage = "Please fill in all fields."
        static let taskNotFoundMessage = "Task not found"
        static let taskDataNotAvailableMessage = "Task data not available"
        static let generalErrorMessage = "An error occurred while loading task. Please try again later."
    }
}
