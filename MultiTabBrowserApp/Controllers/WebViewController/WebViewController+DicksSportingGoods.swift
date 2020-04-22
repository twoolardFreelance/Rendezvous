//
//  WebViewController+dickssportinggoods.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/24.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillDicks(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.contains("/DSGBillingAddressView") {
                injectDicksDelivery(webView)
            } else if url.contains("/DSGPaymentViewCmd") {
                injectDicksPayment(webView)
            }
        }
    }
    
    // auto fill for delivery information
    func injectDicksDelivery(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let phone = currentProfile.phone.replacingOccurrences(of: "+1", with: "")
        let formatedPhoneNumber = phone.formattedNumber(pattern: "(###) ###-####")
        
        let injectString = """
        javascript:(function() {
            try {
                var objs = [
                    {property: 'input[formcontrolname="first_name"]', value: '\(currentProfile.firstName)'},
                    {property: 'input[formcontrolname="last_name"]', value: '\(currentProfile.lastName)'},
                    {property: 'input[formcontrolname="email"]', value: '\(currentProfile.email)'},
                    {property: 'input[formcontrolname="phone"]', value: '\(formatedPhoneNumber)'},
                    {property: 'input[formcontrolname="address"]', value: '\(currentProfile.addressOne)'},
                    {property: 'input[formcontrolname="city"]', value: '\(currentProfile.city)'},
                    {property: 'input[formcontrolname="zipcode"]', value: '\(currentProfile.zipCode)'}
                ];
                objs.forEach(function(obj) {
                    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
                    var elements = document.querySelectorAll(obj.property);
                    if (elements && elements[0]) {
                        setter.call(elements[0], obj.value);
                        elements[0].dispatchEvent(new Event('input', {bubbles:true}));
                        elements[0].dispatchEvent(new Event('blur', {bubbles:true}));
                    }
                });
            } catch (e) {
                window.errStash = e;
            }
        })();
        """
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            webView.evaluateJavaScript(injectString) { (result, error) in
                print(error ?? "result")
            }
        }
        
    }
    
    // auto fill for payment information
    func injectDicksPayment(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let injectString = """
        javascript:(function() {
            try {
                var objs = [
                    {property: '#cc-number', value: '\(currentProfile.cardNumber)'},
                    {property: '#name', value: '\(currentProfile.cardName)'},
                    {property: '#cc-exp-date', value: '\(currentProfile.expDate)'},
                    {property: '#cc-cvc', value: '\(currentProfile.cvv)'},
                ];
                objs.forEach(function(obj) {
                    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
                    var elements = document.querySelectorAll(obj.property);
                    if (elements && elements[0]) {
                        setter.call(elements[0], obj.value);
                        elements[0].dispatchEvent(new Event('input', {bubbles:true}));
                        elements[0].dispatchEvent(new Event('blur', {bubbles:true}));
                    }
                });
            } catch (e) {
                window.errStash = "";
            }
        })();
        """
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            webView.evaluateJavaScript(injectString) { (result, error) in
                print(error ?? "result")
            }
        }
    }
}
