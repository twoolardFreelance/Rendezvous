//
//  WebViewController+Shopify.swift
//  MultiTabBrowserApp
//
//  Created by King on 2019/12/25.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension WebViewController {
    func autofillShopify(_ webView: WKWebView) {
        if let url = webView.url?.absoluteString {
            if url.contains("/checkouts/") {
                if  url.contains("&step=payment_method") {
                    injectShopifyPayment(webView)
                } else {
                    injectShopifyDelivery(webView)
                }
            }
        }
    }
    
    func injectShopifyDelivery(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let injectString = """
            try {
                function autofill(selector, value) {
                    if (selector && value) {
                        var elements = document.querySelectorAll(selector);
                        if (elements && elements[0]) {
                            elements[0].value = value;
                        }
                    }
                };

                autofill("#checkout_shipping_address_first_name", "\(currentProfile.firstName)");
                autofill("#checkout_shipping_address_last_name", "\(currentProfile.lastName)");
                autofill("#checkout_email", "\(currentProfile.email)");
                autofill("#checkout_shipping_address_address1", "\(currentProfile.addressOne)");
                autofill("#checkout_shipping_address_address2", "\(currentProfile.addressTwo)");
                autofill("#checkout_shipping_address_city", "\(currentProfile.city)");
                autofill("#checkout_shipping_address_country", "\(currentProfile.country)");
                autofill("#checkout_shipping_address_province", "\(currentProfile.stateCode)");
                autofill("#checkout_shipping_address_zip", "\(currentProfile.zipCode)");
                autofill("#checkout_shipping_address_phone", "\(currentProfile.phone)");
            } catch (e) {
                window.errStash = e;
            }
        """
        
        if let url = webView.url?.absoluteString {
            autofillUrls.append(url)
        }
        // Inject script into all frames after they finish loading
        let userScript = WKUserScript(source: injectString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.reload()
    }
    
    func injectShopifyPayment(_ webView: WKWebView) {
        guard let currentProfile = selectedProfile else {
            return
        }
        
        let injectString = """
            try {
                function autofill(selector, value) {
                    if (selector && value) {
                        var elements = document.querySelectorAll(selector);
                        if (elements && elements[0]) {
                            elements[0].value = value;
                        }
                    }
                };
        
                autofill("#name", "\(currentProfile.cardName)");
                autofill("#number", "\(currentProfile.cardNumber)");
                autofill("#expiry", "\(currentProfile.expDate)");
                autofill("#verification_value", "\(currentProfile.cvv)");
            } catch (e) {
                window.errStash = e;
            }
        """
        
        if let url = webView.url?.absoluteString {
            autofillUrls.append(url)
        }
        // Inject script into all frames after they finish loading
        let userScript = WKUserScript(source: injectString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.reload()
    }
}
