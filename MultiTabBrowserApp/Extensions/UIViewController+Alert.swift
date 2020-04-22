//
//  UIViewController+Alert.swift
//  MultiTabBrowserApp
//
//  Created by Alex Brown on 10/12/2019.
//  Copyright © 2019 AJB. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
 
    func prsentError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            okAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
