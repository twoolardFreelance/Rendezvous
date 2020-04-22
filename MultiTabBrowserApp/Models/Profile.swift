//
//  Profile.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/18.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation

class Profile: NSObject, NSCoding {
    
    var profileName, firstName, lastName, email, phone, addressOne, addressTwo, city, zipCode, country, countryCode, state, stateCode, cardName, scheme, cardNumber, cvv, expDate: String
    
    init(profileName: String, firstName: String, lastName: String, email: String, phone: String, addressOne: String, addressTwo: String, city: String, zipCode: String, country: String, countryCode: String, state: String, stateCode: String, cardName: String, scheme: String, cardNumber: String, cvv: String, expDate: String) {
        self.profileName = profileName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.addressOne = addressOne
        self.addressTwo = addressTwo
        self.city = city
        self.zipCode = zipCode
        self.country = country
        self.countryCode = countryCode
        self.state = state
        self.stateCode = stateCode
        self.cardName = cardName
        self.scheme = scheme
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.expDate = expDate
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.profileName, forKey: "profileName")
        coder.encode(self.firstName, forKey: "firstName")
        coder.encode(self.lastName, forKey: "lastName")
        coder.encode(self.email, forKey: "email")
        coder.encode(self.phone, forKey: "phone")
        coder.encode(self.addressOne, forKey: "addressOne")
        coder.encode(self.addressTwo, forKey: "addressTwo")
        coder.encode(self.city, forKey: "city")
        coder.encode(self.zipCode, forKey: "zipCode")
        coder.encode(self.country, forKey: "country")
        coder.encode(self.countryCode, forKey: "countryCode")
        coder.encode(self.state, forKey: "state")
        coder.encode(self.stateCode, forKey: "stateCode")
        coder.encode(self.cardName, forKey: "cardName")
        coder.encode(self.scheme, forKey: "scheme")
        coder.encode(self.cardNumber, forKey: "cardNumber")
        coder.encode(self.cvv, forKey: "cvv")
        coder.encode(self.expDate, forKey: "expDate")
    }
    
    // MARK: - NSCoding
    required convenience init?(coder: NSCoder) {
        guard let profileName = coder.decodeObject(forKey: "profileName") as? String,
            let firstName = coder.decodeObject(forKey: "firstName") as? String,
            let lastName = coder.decodeObject(forKey: "lastName") as? String,
            let email = coder.decodeObject(forKey: "email") as? String,
            let phone = coder.decodeObject(forKey: "phone") as? String,
            let addressOne = coder.decodeObject(forKey: "addressOne") as? String,
            let addressTwo = coder.decodeObject(forKey: "addressTwo") as? String,
            let city = coder.decodeObject(forKey: "city") as? String,
            let zipCode = coder.decodeObject(forKey: "zipCode") as? String,
            let country = coder.decodeObject(forKey: "country") as? String,
            let countryCode = coder.decodeObject(forKey: "countryCode") as? String,
            let state = coder.decodeObject(forKey: "state") as? String,
            let stateCode = coder.decodeObject(forKey: "stateCode") as? String,
            let cardName = coder.decodeObject(forKey: "cardName") as? String,
            let scheme = coder.decodeObject(forKey: "scheme") as? String,
            let cardNumber = coder.decodeObject(forKey: "cardNumber") as? String,
            let cvv = coder.decodeObject(forKey: "cvv") as? String,
            let expDate = coder.decodeObject(forKey: "expDate") as? String
            else { return nil }
        
        self.init(profileName: profileName, firstName: firstName, lastName: lastName, email: email, phone: phone, addressOne: addressOne, addressTwo: addressTwo, city: city, zipCode: zipCode, country: country, countryCode: countryCode, state: state, stateCode: stateCode, cardName: cardName, scheme: scheme, cardNumber: cardNumber, cvv: cvv, expDate: expDate)
    }
    
    
}
