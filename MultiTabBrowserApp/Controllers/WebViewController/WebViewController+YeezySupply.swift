//
//  WebViewController+YeezySupply.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/18.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillYeezySupply(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.contains("/delivery") {
                injectYeezySupplyDelivery(webView)
            } else if url.contains("/payment") {
                injectYeezySupplyPayment(webView)
            }
        }
    }
    
    // auto fill for delivery information
    func injectYeezySupplyDelivery(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        let injectString = """
        javascript:(function() {
            try {
                var objs = [
                    {property: '#firstName', value: '\(currentProfile.firstName)'},
                    {property: '#lastName', value: '\(currentProfile.lastName)'},
                    {property: '#address1', value: '\(currentProfile.addressOne)'},
                    {property: '#city', value: '\(currentProfile.city)'},
                    {property: '#zipcode', value: '\(currentProfile.zipCode)'},
                    {property: '#phoneNumber', value: '\(currentProfile.phone)'},
                    {property: '#emailAddress', value: '\(currentProfile.email)'}
                ];
                if ("\(currentProfile.addressTwo)") {
                    objs.push({property: '#address2', value: '\(currentProfile.addressTwo)'});
                }
                objs.forEach(function(obj) {
                    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
                    var elements = document.querySelectorAll(obj.property);
                    if (elements && elements[0]) {
                        setter.call(elements[0], obj.value);
                        elements[0].dispatchEvent(new Event('focus', {bubbles:true}));
                        elements[0].dispatchEvent(new Event('blur', {bubbles:true}));
                    }
                });
                var elements = document.getElementsByTagName('select');
                if (elements && elements[0]) {
                    elements[0].value='\(currentProfile.state)';
                    elements[0].dispatchEvent(new Event('change', { bubbles: true}));
                }
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
    func injectYeezySupplyPayment(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let injectString = """
        javascript:(function() {
            try {
                var objs = [
                    {property: '#card-number', value: '\(currentProfile.cardNumber)'},
                    {property: '#name', value: '\(currentProfile.cardName)'},
                    {property: '#expiryDate', value: '\(currentProfile.expDate)'},
                    {property: '#security-number-field', value: '\(currentProfile.cvv)'},
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            webView.evaluateJavaScript(injectString) { (result, error) in
                print(error ?? "result")
            }
        }
    }
}
