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
    
//    VIEWS
    static let settingsName = "Settings"
    static let profileName = "Profile"
    static let contactUsName = "Contact Us / About Us"
    static let shareName = "Share"
    
//    CELLS
    static let settingsCellIdentifier = "SettingsCell"
    
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
    }
}
