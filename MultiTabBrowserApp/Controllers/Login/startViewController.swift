//
//  startViewController.swift
//  MultiTabBrowserApp
//
//  Created by Banotik on 12/11/19.
//  Copyright © 2019 AJB. All rights reserved.
//

import UIKit

class startViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            performSegue(withIdentifier: "loadHome", sender: nil)
        } else {
            performSegue(withIdentifier: "loadLogin", sender: nil)
        }
    }
}
