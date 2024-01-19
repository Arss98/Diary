//
//  Consts.swift
//  Diary
//
//  Created by  Arsen Dadaev on 28.12.2023.
//

import Foundation

struct Consts {
    struct UIConstants {
        static let customCellIdentifier = "CustomTableViewCell"
        static let selectDateAlertTitle = "Select Date"
        static let addTaskTitle = "New Event"
        static let editTaskTitle = "Edit Event"
        static let saveButtonTitle = "Save"
        static let startDateTitle = "Starts"
        static let endDateTitle = "Ends"
        static let noTasksTitle = "No Events"
        static let okButton = "OK"
        static let backButtonTitle = "Back"
        static let editButtonTitle = "Edit"
        static let deleteButtonTitle = "Delete"
        static let cancelButtonTitle = "Cancel"
    }
    
    struct Placeholders {
        static let placeholderNodeText = "Write a description"
        static let placeholderTaskTitle = "Write the title"
    }
    
    struct Headers {
        static let headerTaskDescription = "Description"
        static let headerTaskTitle = "Title"
        static let tableHeaderView = "Events"
        static let addTaskTitle = "New Event"
        static let editTaskTitle = "Edit Event"
        static let detailTaskTitle = "Event Details"
    }
    
    struct Alerts {
        static let deleteAlertTitle = "Confirmation of deletion"
        static let deleteAlertDescription = "Are you sure you want to delete this task?"
    }
    
    struct ErrorMessages {
        static let errorTitle = "The 'Title' field cannot be empty."
        static let errorDescription = "The 'Description' field cannot be empty."
        static let alertError = "Error"
        static let alertErrorMessage = "Please fill in all fields."
    }
}
