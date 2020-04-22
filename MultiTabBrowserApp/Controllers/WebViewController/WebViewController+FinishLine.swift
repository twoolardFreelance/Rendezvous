//
//  WebViewController+FinishLine.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/27.
//  Copyright © 2019 AJB. All rights reserved.
//

/// Finishline.com autofill
import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillFinishLine(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.contains("/checkout/") {
                injectFinishLineCheckout(webView)
            }
        }
    }
    
    // auto fill for delivery information
    func injectFinishLineCheckout(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let expValues = currentProfile.expDate.split(separator: "/")
        let expMonth = expValues[0]
        let expYear = expValues.count == 2 ? "20\(expValues[1])" : "2020"
        let phone = currentProfile.phone.replacingOccurrences(of: "+1", with: "")
        let formatedPhoneNumber = phone.formattedNumber(pattern: "###-###-####")
        
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
                    {property: '#firstName', value: '\(currentProfile.firstName)'},
                    {property: '#shippingLastName', value: '\(currentProfile.lastName)'},
                    {property: '#shippingAddress1', value: '\(currentProfile.addressOne)'},
                    {property: '#shippingZip', value: '\(currentProfile.zipCode)'},
                    {property: '#shippingCity', value: '\(currentProfile.city)'},
                    {property: '#shippingPhone', value: '\(formatedPhoneNumber)'},
                    {property: '#email', value: '\(currentProfile.email)'},
                    {property: '#billingCardNumber', value: '\(currentProfile.cardNumber)'},
                    {property: '#billingSecurityCode', value: '\(currentProfile.cvv)'}
                ];
                if ("\(currentProfile.addressTwo)") {
                    objs.push({property: '#shippingAddress2', value: '\(currentProfile.addressTwo)'});
                }
                objs.forEach(function(obj) {
                    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
                    var elements = document.querySelectorAll(obj.property);
                    if (elements && elements[0]) {
                        setter.call(elements[0], obj.value);
                        elements[0].dispatchEvent(new Event('input', {bubbles:true}));
                        elements[0].dispatchEvent(new Event('blur', {bubbles:true}));
                    }
                });
        
                autofillSelect('#shippingState', "\(currentProfile.stateCode)");
                autofillSelect('#billingExpirationMonth', "\(expMonth)");
                autofillSelect('#billingExpirationYear', "\(expYear)");
        
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
