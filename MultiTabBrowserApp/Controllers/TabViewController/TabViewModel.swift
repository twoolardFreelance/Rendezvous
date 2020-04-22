//
//  TabViewModel.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 09/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import WebKit

struct TabViewModel {
    // Configuration
    let maxTabs = 500
    let defaultURL = "https://accounts.google.com/signin"
    
    var tabs: [WKWebView] = [WKWebView]()
    let dateFormatter = DateFormatter()
    
    var tabCount: Int {
        return tabs.count
    }
    
    var navigationTitle: String {
        let date = Date()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: date)
    }
    
    mutating func createTab() -> Bool {
        if tabs.count >= maxTabs {
            return false
        }
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        configuration.processPool = WKProcessPool()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .white
        webView.isUserInteractionEnabled = false
        if let url = URL(string: defaultURL) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            tabs.append(webView)
            
        }
        return true
    }
    
    func refreshAll() {
        tabs.forEach { (webView) in
            webView.reload()
        }
    }
    
    mutating func closeAll() {
        tabs.forEach { (webView) in
            webView.removeFromSuperview()
        }
        self.tabs = [WKWebView]()
    }
    
    func changeAll(urlString: String) -> Bool {
        var isValid = true
        if let url = URL(string: urlString.addingProtocol()) {
            tabs.forEach { (webView) in
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        } else {
            isValid = false
        }
        return isValid
    }
    
    mutating func deleteTab(at index: Int) {
        tabs.remove(at: index)
    }
}
