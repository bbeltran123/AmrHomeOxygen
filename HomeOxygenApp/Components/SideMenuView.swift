//
//  SideMenuView.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 25.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import UIKit

class SideMenuView:UIViewController {

    var goToChangePasswordPage:()->()  = {()-> () in }
    var signOutFunction:()->()  = {()-> () in }
    var dismissFunction: (_ completed: @escaping()->())->() = {(completed)-> () in }

    override func viewDidLoad()
    {
        self.goToChangePasswordPage = {() -> () in
            self.performSegue(withIdentifier: "changePassword", sender: self)
        }
    }

    @IBAction func signOut(){
        self.dismissFunction(self.signOutFunction)
    }

    @IBAction func changePasswordPage(){
        self.goToChangePasswordPage()
    }

}
