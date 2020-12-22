//
//  TabBarVC.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 11.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabBarVC: UITabBarController
{
   
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.performSegue(withIdentifier: "authenticate", sender: self)
        }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
