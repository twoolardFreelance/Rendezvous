//
//  signinViewController.swift
//  MultiTabBrowserApp
//
//  Created by Banotik on 12/11/19.
//  Copyright © 2019 AJB. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseDatabase

class signinViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBAction func signButton(_ sender: UIButton) {
        indicator.isHidden = false
        indicator.startAnimating()
        let userDefaults = UserDefaults.standard
        userDefaults.set(emailTextfield.text, forKey: "signinemail")
        userDefaults.set(passwordTextfield.text, forKey: "signinpassword")
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!){ (authResult : AuthDataResult?, error : Error?) in
           print("********************************")
           
           if error != nil {
               self.indicator.stopAnimating()
               self.indicator.isHidden = true
               let alertController = UIAlertController(title: "oops!", message:
                "We were unable to log you in. If this problem persists, please contact us at motionsply@gmail.com", preferredStyle: UIAlertController.Style.alert)
               alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
               
               self.present(alertController, animated: true, completion: nil)
               
               print("Error:")
               print(error!)
           } else {
               self.indicator.stopAnimating()
               self.indicator.isHidden = true
               self.checkForExistingLogins(authResult?.user.uid ?? "")
           }
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        
        if self.emailTextfield.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextfield.text!,  completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextfield.text = ""
                    self.passwordTextfield.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signinBtn.layer.cornerRadius = 20
        indicator.isHidden = true
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            //user is already logged in just navigate him to home screen
            let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self.navigationController?.pushViewController(homeVc!, animated: false)
        }
    }
    
    func checkForExistingLogins(_ userID : String){ Database.database().reference().child("existing_logins").child(userID).observeSingleEvent(of: DataEventType.value) { (dataSnapshot) in
            if(dataSnapshot.exists()){
                //The accountcurrently has an active logged in session
                let alert = UIAlertController(title: "Oops!", message: "You are currently logged in on another device.\nWould you like to force log out of the other device?", preferredStyle: UIAlertController.Style.alert)
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
                    let existingUUID = dataSnapshot.value as! String
                    self.forceLogOutOtherDevice(existingUUID)
                    self.markLoggedInSession(userID)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                })
                let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion: nil)
            }else{
                self.markLoggedInSession(userID)
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
    }
        
    func forceLogOutOtherDevice(_ existingUUID : String) { Database.database().reference().child("logged_in_devices").child(existingUUID).setValue(nil)
    }
       
    func markLoggedInSession (_ userID : String){
        //To get the identifier for iPhone
        let identifier = UIDevice.current.identifierForVendor!.uuidString
    Database.database().reference().child("existing_logins").child(userID).setValue(identifier)
    Database.database().reference().child("logged_in_devices").child(identifier).setValue(true)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
       
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

