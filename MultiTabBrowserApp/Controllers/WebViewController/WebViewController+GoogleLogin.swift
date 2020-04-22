//
//  WebViewController+GoogleLogin.swift
//  MultiTabBrowserApp
//
//  Created by Super on 3/5/20.
//  Copyright © 2020 AJB. All rights reserved.
//

import Foundation
extension WebViewController {
    
    func checkGoogleLogin() {
        if (!Settings.googleAutoFillSwitchFlag) {
            return
        }
        
        if let url = webView?.url?.absoluteString, url.contains("accounts.google.com/signin") ||  url.contains("accounts.google.com/ServiceLogin"){
            
            // Password Enter Screen
            if (url.contains("password") || url.contains("lookup")) {
                
                // Don't run below javascript code if no password is saved
                if (Settings.googleLoginPassword == "") {
                    return
                }
                                
                let injectString = """
                javascript:(function() {
                    document.querySelector('input[type="password"]').value = "\(Settings.googleLoginPassword)"
                })();
                """
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.webView?.evaluateJavaScript(injectString) { (result, error) in
                        self.checkAutoLogin()
                    }
                }
            } else  { // Email Enter Screen
                
                // Don't run below javascript code if no email is saved
                if (Settings.googleLoginEmail == "") {
                    return
                }
                
                let injectString = """
                javascript:(function() {
                    document.querySelector('input[type="email"]').value = "\(Settings.googleLoginEmail)"
                })();
                """
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.webView?.evaluateJavaScript(injectString) { (result, error) in
                        self.checkAutoLogin()
                    }
                }
            }
            
            
        }
    }
    
    func checkAutoLogin(runAfter: Double = 0.0) {
        if (Settings.googleAutoLoginSwitchFlag) {
            let injectString = """
            javascript:(function() {
                var noError = true;
                var hasCaptcha = document.getElementsByClassName("captcha-box").length > 0;
                if (document.getElementsByClassName("error-msg").length > 0) {
                    noError = document.getElementsByClassName("error-msg")[0].textContent.length < 1
                }
                if (document.querySelector('div[role="button"]') != null && noError && !hasCaptcha) {
                    document.querySelector('div[role="button"]').click()
                } else if (document.querySelector("input[type='submit']") != null && noError && !hasCaptcha) {
                    document.querySelector("input[type='submit']").click()
                }
            })();
            """
            DispatchQueue.main.asyncAfter(deadline: .now() + runAfter) {
                self.webView?.evaluateJavaScript(injectString) { (result, error) in
                }
            }
        }
    }
}
