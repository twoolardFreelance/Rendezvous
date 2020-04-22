//
//  SettingsViewController.swift
//  MultiTabBrowserApp
//
//  Created by admin on 2/19/20.
//  Copyright © 2020 AJB. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController {

    @IBOutlet weak var m_topView: UIView!
    
    @IBOutlet weak var m_viewWebhook: UIView!
    @IBOutlet weak var m_txtWebhookUrl: UITextField!
    @IBOutlet weak var my_txtWebhookUrl: TextField!
    
    @IBOutlet weak var m_btnTest: UIButton!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var discordSwitchFlag: UISwitch!
    
    @IBOutlet weak var googleEmailTextField: TextField!
    @IBOutlet weak var googlePasswordTextField: TextField!
    @IBOutlet weak var googleAutoFillSwitch: UISwitch!
    @IBOutlet weak var googleAutoLoginSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
        my_txtWebhookUrl.text = UserDefaults.getUserUrl() // Get the user's url.
//        "\(Global.myWebhookUrl)"
        
        self.initializeUI()
        self.initSwitches()
        self.initGoogleSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveGoogleSettings()
    }
    
    func initSwitches() {
        self.vibrateSwitch.isOn = Settings.vibrateSwitchFlag
        self.soundSwitch.isOn = Settings.soundSwitchFlag
        self.discordSwitchFlag.isOn = Settings.discordSwitchFlag
    }
    
    func initGoogleSettings() {
        self.googleEmailTextField.text = Settings.googleLoginEmail
        self.googlePasswordTextField.text = Settings.googleLoginPassword
        self.googleAutoFillSwitch.isOn = Settings.googleAutoFillSwitchFlag
        self.googleAutoLoginSwitch.isOn = Settings.googleAutoLoginSwitchFlag
    }
    
    func saveGoogleSettings() {
        Settings.googleLoginEmail = self.googleEmailTextField.text ?? ""
        Settings.googleLoginPassword = self.googlePasswordTextField.text ?? ""
    }
    
    func initializeUI() {
        // let commonCornerRadius: CGFloat = 10
       // m_topView.layer.cornerRadius = commonCornerRadius
        //m_topView.clipsToBounds = true
        
       // m_viewWebhook.layer.cornerRadius = commonCornerRadius
       // my_viewWebhook.clipsToBounds = true
        
       // m_txtWebhookUrl.layer.cornerRadius = 3
       // m_txtWebhookUrl.layer.borderWidth = 1
      //  m_txtWebhookUrl.layer.borderColor = UIColor.white.cgColor
      //  m_txtWebhookUrl.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //m_txtWebhookUrl.clipsToBounds = true
        
        m_btnTest.layer.cornerRadius = m_btnTest.frame.height/2
        m_btnTest.clipsToBounds = true
    }

    @IBAction func vibrateSwitchBTN(_ sender: UISwitch) {
        Settings.vibrateSwitchFlag = sender.isOn

    }
    
    @IBAction func soundSwitchChanged(_ sender: UISwitch) {
        Settings.soundSwitchFlag = sender.isOn
    }
    
    @IBAction func discordSwitchChanged(_ sender: UISwitch) {
        Settings.discordSwitchFlag = sender.isOn
    }
    
    @IBAction func btnTestClicked(_ sender: Any) {
        
        UserDefaults.setUserUrl(url: my_txtWebhookUrl.text) // Set user's url
        
        Global.sendWebhookMessage(url: my_txtWebhookUrl.text!, message: DummyData.discordMessageTest) {
            print(">>> Finished!")
        }
    }
    
    @IBAction func googleAutoFillSwitchChanged(_ sender: UISwitch) {
        Settings.googleAutoFillSwitchFlag = sender.isOn
    }
    
    @IBAction func googleAutoLoginSwitchChanged(_ sender: UISwitch) {
        Settings.googleAutoLoginSwitchFlag = sender.isOn
    }
}
