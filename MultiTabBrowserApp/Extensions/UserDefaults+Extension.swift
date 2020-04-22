//
//  UserDefaults+Extension.swift
//  MultiTabBrowserApp
//
//  Created by admin on 2/19/20.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation
extension UserDefaults {
    
    static func getUserUrl() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: "user_discord")
    }
    
    static func setUserUrl(url: String?) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(url, forKey: "user_discord")
        userDefaults.synchronize()
    }
}
