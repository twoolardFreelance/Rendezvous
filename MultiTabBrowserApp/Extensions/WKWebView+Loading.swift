//
//  WKWebView+Loading.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 10/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    
    func addLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tag = 99
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func removeLoading() {
        if let view = viewWithTag(99) {
            view.removeFromSuperview()
        }
    }
}
