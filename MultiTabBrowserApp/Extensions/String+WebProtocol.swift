//
//  String+WebProtocol.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 10/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension String {
    
    func addingProtocol() -> String {
        if self.hasPrefix("http://") || self.hasPrefix("https://") {
            return self
        } else {
            return "http://\(self)"
        }
    }
    
    func isValidCardNumber() -> Bool {
        do {
            try CreditCard.performAlgorithm(with: self)
            return true
        }
        catch {
            return false
        }
    }
    
    func isValidExpDate() -> Bool {

        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)

        let enterdYr = Int(self.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(self.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(self) // This is MM/YY Entered by user

        if enterdYr > currentYear && enterdYr <= currentYear + 15 {
            if (1 ... 12).contains(enterdMonth){
                return true
            } else {
                return false
            }
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                   return true
                }  else {
                   return false
                }
            } else {
                return false
            }
        } else {
           return false
        }
    }
    
    func formattedExpDate() -> String {
        var str = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "##/##"

        if str.count > 0 && str.count < 3 {
            let month = Int(str)!
            if str.count == 1 && month >= 2{
                str = "0" + str
            } else if str.count == 2 && month > 12 {
                str = "0" + str
            }
        }
        
        var result = ""
        var index = str.startIndex
        for ch in mask where index < str.endIndex {
            if ch == "#" {
                result.append(str[index])
                index = str.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isValidCVV() -> Bool {
        let cleanCVV = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if cleanCVV.count == 3 || cleanCVV.count == 4 {
            return true
        } else {
            return false
        }
    }
    
    func formattedCVV() -> String {
        let cleanCVV = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "####"
        
        var result = ""
        var index = cleanCVV.startIndex
        for ch in mask where index < cleanCVV.endIndex {
            if ch == "#" {
                result.append(cleanCVV[index])
                index = cleanCVV.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^[0-9０-９٠-٩۰-۹]{2}$|^[+＋]*(?:[-x\u{2010}-\u{2015}\u{2212}\u{30FC}\u{FF0D}-\u{FF0F} \u{00A0}\u{00AD}\u{200B}\u{2060}\u{3000}()\u{FF08}\u{FF09}\u{FF3B}\u{FF3D}.\\[\\]/~\u{2053}\u{223C}\u{FF5E}*]*[0-9\u{FF10}-\u{FF19}\u{0660}-\u{0669}\u{06F0}-\u{06F9}]){3,}[-x\u{2010}-\u{2015}\u{2212}\u{30FC}\u{FF0D}-\u{FF0F} \u{00A0}\u{00AD}\u{200B}\u{2060}\u{3000}()\u{FF08}\u{FF09}\u{FF3B}\u{FF3D}.\\[\\]/~\u{2053}\u{223C}\u{FF5E}*A-Za-z0-9\u{FF10}-\u{FF19}\u{0660}-\u{0669}\u{06F0}-\u{06F9}]*(?:(?:;ext=([0-9０-９٠-٩۰-۹]{1,7})|[  \\t,]*(?:e?xt(?:ensi(?:ó?|ó))?n?|ｅ?ｘｔｎ?|[,xｘX#＃~～;]|int|anexo|ｉｎｔ)[:\\.．]?[  \\t,-]*([0-9０-９٠-٩۰-۹]{1,7})#?|[- ]+([0-9０-９٠-٩۰-۹]{1,5})#)?$)?[,;]*$"
//        let PHONE_REGEX = "^[+1|+1 ]?[(]([2-9][0-8][0-9])[)] ([2-9][0-9]{2})-([0-9]{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func formattedNumber(pattern: String?) -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = "(###) ###-####"
        if let pattern = pattern {
            mask = pattern
        }

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
}
