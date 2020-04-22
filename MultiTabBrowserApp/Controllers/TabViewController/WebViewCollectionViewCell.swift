//
//  WebViewCollectionViewCell.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 09/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewCollectionViewCellDelegate: class {
    func closeTab(_ tab: WebViewCollectionViewCell)
}

class WebViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    
    private(set) var webView: WKWebView?
    private(set) var number: Int = 0
    
    weak var delegate: WebViewCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSurroundShadow()
        containerView.layer.cornerRadius = 10.0
    }

    func addWebview(webView: WKWebView) {
        self.webView = webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webViewContainer.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor),
            webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor),
        ])
        layoutIfNeeded()
    }

    func updateIndex(_ index: Int) {
        numberLabel.text = "\(index)"
    }
    
    @IBAction func closeTabButtonPressed(_ sender: Any) {
        delegate?.closeTab(self)
    }
}
