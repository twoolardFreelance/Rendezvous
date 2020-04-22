//
//  WebViewController+OffCenterOfficial.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/27.
//  Copyright © 2019 AJB. All rights reserved.
//

/// FootAction.com autofill for OffCenterOfficial
import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillOffCenterOffical(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.hasSuffix("/checkout") {
                injectOffCenterCheckout(webView)
            }
        }
    }
    
    // auto fill for delivery information
    func injectOffCenterCheckout(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let injectString = """
        javascript:(function() {
            try {
                function autofillSelect(selector, value) {
                    if (selector && value) {
                        var elements = document.querySelectorAll(selector);
                        if (elements && elements[0]) {
                            elements[0].value = value;
                            elements[0].dispatchEvent(new Event('change', { bubbles: true}));
                        }
                    }
                };
        
                var objs = [
                    {property: 'input[name="email"]', value: '\(currentProfile.email)'},
                    {property: 'input[name="fname"]', value: '\(currentProfile.firstName)'},
                    {property: 'input[name="lname"]', value: '\(currentProfile.lastName)'},
                    {property: 'input[name="street-address address-line1"]', value: '\(currentProfile.addressOne)'},
                    {property: 'input[name="street-address address-line2"]', value: '\(currentProfile.addressTwo)'},
                    {property: 'input[name="postal-code zip-code zip"]', value: '\(currentProfile.zipCode)'},
                    {property: 'input[name="address-level2 city"]', value: '\(currentProfile.city)'},
                    {property: 'input[autocomplete="tel"]', value: '\(currentProfile.phone)'},
                    {property: 'input[name="cardnumber"]', value: '\(currentProfile.cardNumber)'},
                    {property: 'input[name="exp-date"]', value: '\(currentProfile.expDate)'},
                    {property: 'input[name="cvc"]', value: '\(currentProfile.cvv)'}
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
        
                autofillSelect('select[name="country"]', "\(currentProfile.countryCode)");
                autofillSelect('select[name="address-level1 region"]', "\(currentProfile.stateCode)");
                
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
    
}
