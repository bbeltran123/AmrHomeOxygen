//
//  ChangePasswordVC.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 25.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//
import UIKit
import FirebaseAuth

class ChangePasswordVC: UIViewController {

    @IBOutlet var changeButton: UIButton?
    @IBOutlet var containerView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        containerView?.layer.cornerRadius = 10
//        self.changeButton?.layer.cornerRadius = 10
        didRequestPasswordReset(self)
    }

    func didRequestPasswordReset(_ sender: AnyObject) {
        showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
            guard let strongSelf = self, let email = email else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            let usermail =  Auth.auth().currentUser?.email
            if email != usermail{
                self!.showMessagePrompt("Incorrect email address", {
                (action)->() in
                    self?.didRequestPasswordReset(self!)
                })
                return
            }
            strongSelf.showSpinner {
                // [START password_reset]
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    
                // [START_EXCLUDE]
                    strongSelf.hideSpinner {
                        if let error = error {
                            strongSelf.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        strongSelf.showMessagePrompt("Sent",{
                            (action)->() in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }// [END_EXCLUDE]
                }// [END password_reset]
            }
        }
    }

}
