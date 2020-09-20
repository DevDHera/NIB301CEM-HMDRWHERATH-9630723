//
//  Constants.swift
//  HMDRWHERATH_9630723_COBSCCOMP191P-008
//
//  Created by user180410 on 9/17/20.
//  Copyright © 2020 Devin Herath. All rights reserved.
//

struct Constants {
//    SEGUES
    static let loginSegue = "LoginToStatus"
    static let registerSegue = "RegisterToStatus"
    static let settingsToProfileSegue = "SettingsToProfile"
    static let settingsToContactUsSegue = "SettingsToContactUs"
    static let settingsToShareSegue = "SettingsToShare"
    static let statusToCreateNotification = "StatusToCreateNotification"
    static let statusToSurvey = "StatusToSurvey"
    
//    VIEWS
    static let settingsName = "Settings"
    static let profileName = "Profile"
    static let contactUsName = "Contact Us / About Us"
    static let shareName = "Share"
    static let allNotifications = "All Notifications"
    static let safeActions = "Safe Actions"
    
//    CELLS
    static let settingsCellIdentifier = "SettingsCell"
    static let notificationCellIdentifier = "NotificationCell"
    
//    COLLECTIONS
    struct UserStore {
        static let collectionName = "users"
        static let uidField = "uid"
        static let firstNameField = "firstName"
        static let lastNameField = "lastName"
        static let emailField = "email"
        static let bodyTemperatureField = "bodyTemp"
        static let roleField = "role"
        static let lastBodyTempUpdatedAtField = "lastBodyTempUpdatedAt"
        static let joinedDateField = "joinedDate"
        static let profileImageField = "profileImage"
        static let location = "location"
        static let covidStatus = "covidStatus"
        static let surveyResultField = "surveyResult"
    }
    
    struct NotificationStore {
        static let collectionName = "notifications"
        static let titleField = "title"
        static let descriptionField = "description"
        static let createdAtField = "createdAt"
    }
    
//    Storage
    struct Storage {
        static let path = "uploads/profile"
    }
}
