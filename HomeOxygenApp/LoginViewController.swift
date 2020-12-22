//
//  LoginViewController.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 10.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        let img = UIImage(named: "bg1")
        containerView.layer.cornerRadius = 10
        signInButton.layer.cornerRadius = 18
        self.view.backgroundColor = UIColor(patternImage: img!)
    }
    
}
