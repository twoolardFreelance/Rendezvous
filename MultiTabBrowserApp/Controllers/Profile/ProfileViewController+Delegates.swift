//
//  ProfileViewController+StatePicker.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/18.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import CountryPickerView

// MARK: - UITextField delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryTextField {
            cpvInternal.showCountriesList(from: self)
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let updatedString = text.replacingCharacters(in: range, with: string)
        
        if textField == cardNumberTextField {
            do {
                let cardType = try CreditCard.cardType(for: updatedString, suggest: true)
                schemeTextField.text = cardType.stringValue()
            } catch {
                schemeTextField.text = "---"
            }
            cardImageView.image = getCardImage(updatedString)
            
            let cardNumber = CreditCard.formattedNumber(with: updatedString)
            if CreditCard.isValidEditable(with: updatedString) {
                cardNumberTextField.text = cardNumber
            }
            let isValid = cardNumber.isValidCardNumber()
            if isValid {
                cardNumberTextField.rightView?.isHidden = true
                expDateTextField.becomeFirstResponder()
            } else {
                cardNumberTextField.rightView?.isHidden = false
            }
            return false
        } else if textField == expDateTextField {
            let expDate = updatedString.formattedExpDate()
            let isValid = expDate.isValidExpDate()
            textField.text = expDate
            if isValid {
                expDateTextField.rightView?.isHidden = true
                cvvTextField.becomeFirstResponder()
            } else {
                expDateTextField.rightView?.isHidden = false
            }
            return false
        } else if textField == cvvTextField {
            var cvv = updatedString.formattedCVV()
            let isValid = cvv.isValidCVV()
            if cvv.count > 4 {
                cvv = cvv[0..<4]
            }
            textField.text = cvv
            if isValid {
//                textField.endEditing(true)
            }
            return false
        } else if textField == zipCodeTextField {
            if updatedString.count <= 10 {
                textField.text = updatedString
            }
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if textField == profileTextField {
            if isValidProfileName(str) {
                textField.rightView?.isHidden = true
            } else {
                textField.rightView?.isHidden = false
            }
        } else if textField == firstNameTextField ||
            textField == lastNameTextField ||
            textField == addressOneTextField ||
            textField == cityTextField ||
            textField == schemeTextField
        {
            textField.rightView?.isHidden = !str.isEmpty
        } else if textField == cardNumberTextField {
            textField.rightView?.isHidden = str.isValidCardNumber()
        } else if textField == expDateTextField {
            textField.rightView?.isHidden = str.isValidExpDate()
        } else if textField == cvvTextField {
            textField.rightView?.isHidden = str.isValidCVV()
        } else if textField == zipCodeTextField {
            textField.rightView?.isHidden = (str.count >= 4 && str.count <= 10)
        } else if textField == emailTextField {
            textField.rightView?.isHidden = str.isValidEmail()
        } else if textField == phoneTextField {
            textField.rightView?.isHidden = str.isValidPhone()
        }
    }
}

// MARK: - UIPickerView dataSource
extension ProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePicker {
            return sortedStateValues.count
        } else if pickerView == profilePicker {
            return Global.getProfiles().count
        }
        return 0
    }
}

// MARK: - UIPickerView delegate
extension ProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statePicker {
            return sortedStateValues[row]
        } else if pickerView == profilePicker {
            return Global.getProfiles()[row].profileName
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePicker {
            stateTextField.text = sortedStateValues[row]
            stateCode = sortedStateKeys[row]
        } else if pickerView == profilePicker {
            if Global.getProfiles().count > row {
                let profile = Global.getProfiles()[row]
                setProfile(profile)
            }
        }
    }
}

// MARK: - CountryPickerView delegate
extension ProfileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryTextField.text = country.name
        countryCode = country.code
        if country.code == "US" {
            stateTextField.inputView = statePicker
            stateTextField.showDoneButtonOnKeyboard()
        } else {
            stateTextField.inputView = nil
        }
    }
}

// MARK: - CountryPickerView DataSource
extension ProfileViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        var countries = [Country]()
        ["US"].forEach { code in
            if let country = countryPickerView.getCountryByCode(code) {
                countries.append(country)
            }
        }
        return countries
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Preferred Countries"
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
}

// MARK: - CardIO delegate
extension ProfileViewController: CardIOPaymentViewControllerDelegate {
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        print("userDidCancel")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        print("userDidProvide")
        let expiryMonth = cardInfo.expiryMonth > 9 ? "\(cardInfo.expiryMonth)" : "0\(cardInfo.expiryMonth)"
        let expiryYear = cardInfo.expiryYear - 2000
        let expDate = "\(expiryMonth)/\(expiryYear)"
        
        cardNumberTextField.text = CreditCard.formattedNumber(with: cardInfo.cardNumber)
        expDateTextField.text = expDate
        cvvTextField.text = cardInfo.cvv
        
        cardNumberTextField.rightView?.isHidden = true
        expDateTextField.rightView?.isHidden = true
        cvvTextField.rightView?.isHidden = true
        
        cardImageView.image = getCardImage(cardInfo.cardNumber)
        do {
            let cardType = try CreditCard.cardType(for: cardInfo.cardNumber, suggest: true)
            schemeTextField.text = cardType.stringValue()
        } catch {
            schemeTextField.text = "---"
        }
        
        paymentViewController.dismiss(animated: true, completion: nil)
    }
}
