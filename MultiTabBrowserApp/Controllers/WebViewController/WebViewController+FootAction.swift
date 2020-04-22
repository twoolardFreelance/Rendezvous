//
//  WebViewController+footaction.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/27.
//  Copyright © 2019 AJB. All rights reserved.
//

/// FootAction.com autofill
import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillFootAction(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.hasSuffix("/checkout") {
                injectFootActionCheckout(webView)
            }
        }
    }
    
    // auto fill for delivery information
    func injectFootActionCheckout(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let expValues = currentProfile.expDate.split(separator: "/")
        let expMonth = expValues[0]
        let expYear = expValues.count == 2 ? "20\(expValues[1])" : "2020"
        var phoneNumber = currentProfile.phone.replacingOccurrences(of: "+1", with: "")
        phoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
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
                    {property: '#input_text_firstName', value: '\(currentProfile.firstName)'},
                    {property: '#input_text_lastName', value: '\(currentProfile.lastName)'},
                    {property: '#input_text_line1', value: '\(currentProfile.addressOne)'},
                    {property: '#input_text_line2', value: '\(currentProfile.addressTwo)'},
                    {property: '#input_text_postalCode', value: '\(currentProfile.zipCode)'},
                    {property: '#input_text_town', value: '\(currentProfile.city)'},
                    {property: '#input_tel_phone', value: '\(phoneNumber)'},
                    {property: '#input_email_email', value: '\(currentProfile.email)'},
                    {property: '#input_tel_cardNumber', value: '\(currentProfile.cardNumber)'},
                    {property: '#input_tel_CSC', value: '\(currentProfile.cvv)'}
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
        
                autofillSelect('#select_country', "\(currentProfile.countryCode)");
                autofillSelect('#select_region', "\(currentProfile.stateCode)");
                autofillSelect('#select_expiryMonth', "\(expMonth)");
                autofillSelect('#select_expiryYear', "\(expYear)");
        
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
