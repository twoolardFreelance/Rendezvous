//
//  Settings.swift
//  MultiTabBrowserApp
//
//  Created by Super on 3/5/20.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation
struct Settings {
    fileprivate struct Keys {
        static let GoogleAutoFillSwitchFlag   = "GoogleAutoFillSwitchFlag"
        static let GoogleAutoLoginSwitchFlag  = "GoogleAutoLoginSwitchFlag"
        static let GoogleLoginEmail           = "GoogleLoginEmail"
        static let GoogleLoginPassword        = "GoogleLoginPassword"
        static let VibrateSwitchFlag          = "VibrateSwitchFlag"
        static let SoundSwitchFlag            = "SoundSwitchFlag"
        static let DiscordSwitchFlag          = "DiscordSwitchFlag"
    }
    
    // Google Auto Fill Switch
    static var googleAutoFillSwitchFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.GoogleAutoFillSwitchFlag)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.GoogleAutoFillSwitchFlag)
        }
    }
    
    // Google Auto Login Switch
    static var googleAutoLoginSwitchFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.GoogleAutoLoginSwitchFlag)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.GoogleAutoLoginSwitchFlag)
        }
    }
        
    // Google Login Email
    static var googleLoginEmail: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.GoogleLoginEmail)
        }
        get {
            return UserDefaults.standard.string(forKey: Keys.GoogleLoginEmail) ?? ""
        }
    }
    
    // Google Login Password
    static var googleLoginPassword: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.GoogleLoginPassword)
        }
        get {
            return UserDefaults.standard.string(forKey: Keys.GoogleLoginPassword) ?? ""
        }
    }
    
    // Vibrate Switch Flag
    static var vibrateSwitchFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.VibrateSwitchFlag)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.VibrateSwitchFlag)
        }
    }
    
    // Sound Switch Flag
    static var soundSwitchFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.SoundSwitchFlag)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.SoundSwitchFlag)
        }
    }
    
    // Discord Switch Flag
    static var discordSwitchFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.DiscordSwitchFlag)
        }
        get {
            return UserDefaults.standard.bool(forKey: Keys.DiscordSwitchFlag)
        }
    }
    
}
