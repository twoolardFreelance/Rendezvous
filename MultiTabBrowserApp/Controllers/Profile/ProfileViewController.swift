//
//  ProfileViewController.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/17.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit
import CountryPickerView
import PhoneNumberKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    @IBOutlet weak var addressOneTextField: TextField!
    @IBOutlet weak var addressTwoTextField: TextField!
    @IBOutlet weak var cityTextField: TextField!
    @IBOutlet weak var zipCodeTextField: TextField!
    @IBOutlet weak var countryTextField: TextField!
    @IBOutlet weak var stateTextField: TextField!
    
    @IBOutlet weak var cardNameTextField: TextField!
    @IBOutlet weak var schemeTextField: TextField!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNumberTextField: TextField!
    @IBOutlet weak var expDateTextField: TextField!
    @IBOutlet weak var cvvTextField: TextField!
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    let cpvInternal = CountryPickerView()
    let statePicker = UIPickerView()
    let profilePicker = UIPickerView()
    
    var profiles: [Profile] = [Profile]()
    var sortedStateKeys: [String] = []
    var sortedStateValues: [String] = []
    var selectedProfile: Profile?
    var countryCode: String?
    var stateCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CardIOUtilities.preload()
        
        prepareCPVInternal()
        preparePickerTextField()
        preparePhoneTextField()
        initData()
        
        statePicker.delegate = self
        statePicker.dataSource = self
        
        setProfile(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigation()
    }
    
    func initData() {
        profiles = Global.getProfiles()
        sortedStateKeys = Array(Global.states.keys).sorted(by: <)
        for key in sortedStateKeys {
            if let value = Global.states[key] {
                sortedStateValues.append(value)
            }
        }
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClickAdd() {
        setProfile(nil)
    }
    
    func setProfile(_ profile: Profile?) {
        selectedProfile = profile
        
        pickerTextField.text = profile?.profileName ?? "---"
        btnDelete.isEnabled = profile != nil
        btnDelete.tintColor = btnDelete.isEnabled ? UIColor.white : UIColor.lightGray
        
        profileTextField.text = profile?.profileName ?? ""
        profileTextField.rightView?.isHidden = true
        
        firstNameTextField.text = profile?.firstName ?? ""
        firstNameTextField.rightView?.isHidden = true
        
        lastNameTextField.text = profile?.lastName ?? ""
        lastNameTextField.rightView?.isHidden = true
        
        emailTextField.text = profile?.email ?? ""
        emailTextField.rightView?.isHidden = true
        
        phoneTextField.text = profile?.phone ?? ""
        phoneTextField.rightView?.isHidden = true
        
        addressOneTextField.text = profile?.addressOne ?? ""
        addressOneTextField.rightView?.isHidden = true
        
        addressTwoTextField.text = profile?.addressTwo ?? ""
        addressTwoTextField.rightView?.isHidden = true
        
        cityTextField.text = profile?.city ?? ""
        cityTextField.rightView?.isHidden = true
        
        zipCodeTextField.text = profile?.zipCode ?? ""
        zipCodeTextField.rightView?.isHidden = true
        
        countryTextField.text = profile?.country ?? ""
        countryTextField.rightView?.isHidden = true
        
        stateTextField.text = profile?.state ?? ""
        stateTextField.rightView?.isHidden = true
        
        cardNameTextField.text = profile?.cardName ?? ""
        cardNameTextField.rightView?.isHidden = true
        
        schemeTextField.text = profile?.scheme ?? ""
        schemeTextField.rightView?.isHidden = true
        
        cardNumberTextField.text = CreditCard.formattedNumber(with: profile?.cardNumber ?? "")
        cardNumberTextField.rightView?.isHidden = true
        
        expDateTextField.text = profile?.expDate ?? ""
        expDateTextField.rightView?.isHidden = true
        
        cvvTextField.text = profile?.cvv ?? ""
        cvvTextField.rightView?.isHidden = true
        
        let cardImage = getCardImage(profile?.cardNumber ?? "")
        cardImageView.image = cardImage
        
        let cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 24))
        cardImageView.image = cardImage
        cardImageView.contentMode = .scaleAspectFit
        pickerTextField.leftView = cardImageView
        
        if let country = profile?.country, country == "United States" {
            stateTextField.inputView = statePicker
            stateTextField.showDoneButtonOnKeyboard()
        } else {
            stateTextField.inputView = nil
        }
        
        if let cCode = profile?.countryCode {
            countryCode = cCode
        }
        
        if let sCode = profile?.stateCode {
            stateCode = sCode
        }
    }
    
    func getCardImage(_ cardNumber: String) -> UIImage {
        do {
            let cardType = try CreditCard.cardType(for: cardNumber, suggest: true)
            return cardType.image()
        } catch {
            return UIImage(named: "card")!
        }
    }
    
    func isValidProfileName(_ name: String) -> Bool {
        if name.isEmpty {
            return false
        }
        
        if profiles.count > 0 {
            for item in profiles {
                if item.profileName == name {
                    return false
                }
            }
        }
        return true
    }
}

// MARK: - IBActions
extension ProfileViewController {
    
    @IBAction func onClickSave(_ sender: Any) {
        var isValid = true
        
        let profileName = profileTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if profileName.isEmpty {
            isValid = false
            profileTextField.rightView?.isHidden = false
            profileTextField.becomeFirstResponder()
        } else if selectedProfile == nil && !isValidProfileName(profileName) {
            isValid = false
            profileTextField.rightView?.isHidden = false
            profileTextField.becomeFirstResponder()
        } else {
            profileTextField.rightView?.isHidden = true
        }
        
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if firstName.isEmpty {
            firstNameTextField.rightView?.isHidden = false
            if isValid {
                firstNameTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            firstNameTextField.rightView?.isHidden = true
        }
        
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if lastName.isEmpty {
            lastNameTextField.rightView?.isHidden = false
            if isValid {
                lastNameTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            lastNameTextField.rightView?.isHidden = true
        }
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if email.isValidEmail() {
            emailTextField.rightView?.isHidden = true
        } else {
            emailTextField.rightView?.isHidden = false
            if isValid {
                emailTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        let phone = phoneTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if phone.isValidPhone() {
            phoneTextField.rightView?.isHidden = true
        } else {
            phoneTextField.rightView?.isHidden = false
            if isValid {
                phoneTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        let addressOne = addressOneTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if addressOne.isEmpty {
            addressOneTextField.rightView?.isHidden = false
            if isValid {
                addressOneTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            addressOneTextField.rightView?.isHidden = true
        }
        
        let addressTwo = addressTwoTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
//        if addressTwo.isEmpty {
//            addressTwoTextField.rightView?.isHidden = false
//            if isValid {
//                addressTwoTextField.becomeFirstResponder()
//            }
//            isValid = false
//        } else {
//            addressTwoTextField.rightView?.isHidden = true
//        }
        
        let city = cityTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if city.isEmpty {
            cityTextField.rightView?.isHidden = false
            if isValid {
                cityTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            cityTextField.rightView?.isHidden = true
        }
        
        let zipCode = zipCodeTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if zipCode.count >= 4 && zipCode.count <= 10 {
            zipCodeTextField.rightView?.isHidden = true
        } else {
            zipCodeTextField.rightView?.isHidden = false
            if isValid {
                zipCodeTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        let country = countryTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if country.isEmpty {
            countryTextField.rightView?.isHidden = false
            isValid = false
        } else {
            countryTextField.rightView?.isHidden = true
        }
        
        let state = stateTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if state.isEmpty {
            stateTextField.rightView?.isHidden = false
            if isValid {
                stateTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            stateTextField.rightView?.isHidden = true
        }
        
        let cardName = cardNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if cardName.isEmpty {
            cardNameTextField.rightView?.isHidden = false
            if isValid {
                cardNameTextField.becomeFirstResponder()
            }
            isValid = false
        } else {
            cardNameTextField.rightView?.isHidden = true
        }
        
        let scheme = schemeTextField.text?.trimmingCharacters(in: .whitespaces) ?? "---"
        
        let cardNumber = cardNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if cardNumber.isValidCardNumber() {
            cardNumberTextField.rightView?.isHidden = true
        } else {
            cardNumberTextField.rightView?.isHidden = false
            if isValid {
                cardNumberTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        let expDate = expDateTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if expDate.isValidExpDate() {
            expDateTextField.rightView?.isHidden = true
        } else {
            expDateTextField.rightView?.isHidden = false
            if isValid {
                expDateTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        let cvv = cvvTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if cvv.isValidCVV() {
            cvvTextField.rightView?.isHidden = true
        } else {
            cvvTextField.rightView?.isHidden = false
            if isValid {
                cvvTextField.becomeFirstResponder()
            }
            isValid = false
        }
        
        if isValid {
            if let profile = selectedProfile {
                var index = -1
                for (idx, item) in profiles.enumerated() {
                    if item.profileName == profile.profileName {
                        index = idx
                        break
                    }
                }
                
                profile.profileName = profileName
                profile.firstName = firstName
                profile.lastName = lastName
                profile.email = email
                profile.phone = phone
                profile.addressOne = addressOne
                profile.addressTwo = addressTwo
                profile.city = city
                profile.zipCode = zipCode
                profile.country = country
                profile.countryCode = countryCode ?? ""
                profile.state = state
                profile.stateCode = stateCode ?? ""
                profile.cardName = cardName
                profile.scheme = scheme
                profile.cardNumber = cardNumber
                profile.cvv = cvv
                profile.expDate = expDate
                
                if index > -1 {
                    profiles.remove(at: index)
                    profiles.insert(profile, at: index)
                } else {
                    profiles.append(profile)
                }
            } else {
                let profile = Profile(profileName: profileName, firstName: firstName, lastName: lastName, email: email, phone: phone, addressOne: addressOne, addressTwo: addressTwo, city: city, zipCode: zipCode, country: country, countryCode: countryCode ?? "", state: state, stateCode: stateCode ?? "", cardName: cardName, scheme: scheme, cardNumber: cardNumber, cvv: cvv, expDate: expDate)
                
                profiles.append(profile)
            }
            
            Global.setProfiles(profiles)
            
            let alertController = UIAlertController(title: "Profile Saved", message: "your Profile was successfully saved. To add new profile, please tap the 'Add More' button.", preferredStyle: .alert)
            let addMoreAction = UIAlertAction(title: "Add More", style: .default) { _ in
                self.setProfile(nil)
            }
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(addMoreAction)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Profile", message: "Are you sure you want to delete this profile? This action cannot be undone.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            if let profile = self.selectedProfile {
                var index = -1
                for (idx, item) in self.profiles.enumerated() {
                    if item.profileName == profile.profileName {
                        index = idx
                        break
                    }
                }
                
                if index > -1 {
                    self.profiles.remove(at: index)
                    Global.setProfiles(self.profiles)
                }
            }
            
            self.setProfile(nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickScan(_ sender: Any) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)!
        cardIOVC.modalPresentationStyle = .currentContext
        self.present(cardIOVC, animated: true, completion: nil)
    }
}



// MARK: - Private functions
fileprivate extension ProfileViewController {
    func prepareNavigation() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "Profiles"
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "left"), style: .plain, target: self, action: #selector(onClickBack))
        self.navigationItem.leftBarButtonItem = leftItem
        let rightItem = UIBarButtonItem(image: UIImage(named: "add-circle"), style: .plain, target: self, action: #selector(onClickAdd))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func prepareCPVInternal() {
        cpvInternal.dataSource = self
        cpvInternal.delegate = self
        cpvInternal.font = UIFont.systemFont(ofSize: 17)
        cpvInternal.showPhoneCodeInView = false
        cpvInternal.showCountryCodeInView = false
    }
    
    func preparePickerTextField() {
        let cardImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 24))
        cardImage.image = UIImage(named: "card")
        cardImage.contentMode = .scaleAspectFit
        
        let downImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 16))
        downImage.image = UIImage(named: "down")
        downImage.contentMode = .scaleAspectFit
        
        pickerTextField.leftView = cardImage
        pickerTextField.leftViewMode = .always
        pickerTextField.rightView = downImage
        pickerTextField.rightViewMode = .always
        
        pickerTextField.inputView = profilePicker
        profilePicker.delegate = self
        profilePicker.dataSource = self
        
        schemeTextField.isEnabled = false
    }
    
    func preparePhoneTextField() {
        phoneTextField.withFlag = true
        phoneTextField.withPrefix = true
        phoneTextField.withExamplePlaceholder = true
        phoneTextField.placeholder = "Phone Number"
        phoneTextField.showDoneButtonOnKeyboard()
        phoneTextField.isPartialFormatterEnabled = true
        
        let attributedString = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 255, green: 255, blue: 255, alpha: 0.5),
            NSAttributedString.Key.font: phoneTextField.font!
        ]
        phoneTextField.attributedPlaceholder = NSAttributedString(string: phoneTextField.placeholder!, attributes: attributedString)
        
        // set right view
        let errorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 16))
        errorImageView.image = UIImage(named: "error")
        errorImageView.contentMode = .scaleAspectFit
        
        phoneTextField.rightView = errorImageView
        phoneTextField.rightViewMode = .always
        phoneTextField.rightView?.isHidden = true
    }
    
    
}
