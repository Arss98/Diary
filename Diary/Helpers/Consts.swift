//
//  Consts.swift
//  Diary
//
//  Created by  Arsen Dadaev on 28.12.2023.
//

import Foundation

struct Consts {
    static let customCellIdentifier = "CustomTableViewCell"
    static let tableHeaderView = "Events"
    static let selectDateAlertTitle = "Select Date"
    static let placeholderNodeText = "Write a description"
    static let placeholderTaskTitle = "Write the title"
    static let headerTaskDescription = "Description"
    static let headerTaskTitle = "Title"
    static let AddTaskTitle = "New Event"
    static let saveButtonTitle = "Save"
    static let startDateTitle = "Starts"
    static let endDateTitle = "Ends"
    static let noTasksLAbel = "No Events"
    static let ok = "OK"
 
    struct ErrorMessage {
        static let errorTitle = "The 'Title' field cannot be empty."
        static let errorDescription = "The 'Description' field cannot be empty."
        static let alertError = "Error"
        static let alertErrorMessage = "Please fill in all fields." 
    }
}
