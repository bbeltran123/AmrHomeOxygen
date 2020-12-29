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

    var sideMenuNav: SideMenuNavigationController?
    
    override func viewDidLoad() {
        let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if((user == nil)){
                self.performSegue(withIdentifier: "authenticate", sender: self)
            }
        }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController!.setNavigationBarHidden(false, animated: false)
    }

    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
            self.performSegue(withIdentifier: "authenticate", sender: self)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sideMenu") {
            self.sideMenuNav = (segue.destination as! SideMenuNavigationController)
            let menu = sideMenuNav?.viewControllers[0] as! SideMenuView
            menu.signOutFunction = {()->() in
                self.signOut()
            }
            menu.dismissFunction = {(completed) -> () in
                self.sideMenuNav?.dismiss(animated: false, completion: completed)
            }
        }
    }
}
