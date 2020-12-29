//
//  LoginVC.swift
//  HomeOxygenApp
//
//  Created by Amr Mousa on 11.8.2020.
//  Copyright © 2020 Amr Mousa. All rights reserved.
//

import UIKit

import FirebaseAuth

class LoginVC: UIViewController {

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  //@IBOutlet var containerView: UIView!
  @IBOutlet var signInButton: UIButton!

  override func viewDidLoad() {
      let img = UIImage(named: "bg1")
      //containerView.layer.cornerRadius = 10
    self.navigationController?.setNavigationBarHidden(true, animated: false)
        containerView.layer.cornerRadius = 10
      signInButton.layer.cornerRadius = 18
      self.view.backgroundColor = UIColor(patternImage: img!)
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
    
  @IBAction func didTapEmailLogin(_ sender: AnyObject) {
    guard let email = self.emailField.text, let password = self.passwordField.text else {
      self.showMessagePrompt("email/password can't be empty")
      return
    }
    showSpinner {
      // [START headless_email_auth]
      Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
        guard let strongSelf = self else { return }
        // [START_EXCLUDE]
        strongSelf.hideSpinner {
          if let error = error {
            let authError = error as NSError
            if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
              // The user is a multi-factor user. Second factor challenge is required.
              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
              var displayNameString = ""
              for tmpFactorInfo in (resolver.hints) {
                displayNameString += tmpFactorInfo.displayName ?? ""
                displayNameString += " "
              }
              self!.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
                var selectedHint: PhoneMultiFactorInfo?
                for tmpFactorInfo in resolver.hints {
                  if (displayName == tmpFactorInfo.displayName) {
                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                  }
                }
                PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
                  if error != nil {
                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
                  } else {
                    self!.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
                      resolver.resolveSignIn(with: assertion!) { authResult, error in
                        if error != nil {
                          print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
                        } else {
                          strongSelf.navigationController?.popViewController(animated: true)
                        }
                      }
                    })
                  }
                }
              })
            } else {
              strongSelf.showMessagePrompt(error.localizedDescription)
              return
            }
          }
            self?.navigationController?.popToRootViewController(animated: false)
        }
        // [END_EXCLUDE]
      }
      // [END headless_email_auth]
    }
  }

  /** @fn requestPasswordReset
   @brief Requests a "password reset" email be sent.
   */
//  @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
//    showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
//      guard let strongSelf = self, let email = email else {
//        return
//      }
//      strongSelf.showSpinner {
//        // [START password_reset]
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//          // [START_EXCLUDE]
//          strongSelf.hideSpinner {
//            if let error = error {
//              strongSelf.showMessagePrompt(error.localizedDescription)
//              return
//            }
//            strongSelf.showMessagePrompt("Sent")
//          }
//          // [END_EXCLUDE]
//        }
//        // [END password_reset]
//      }
//    }
//  }

  /** @fn getProvidersForEmail
   @brief Prompts the user for an email address, calls @c FIRAuth.getProvidersForEmail:callback:
   and displays the result.
   */
//  @IBAction func didGetProvidersForEmail(_ sender: AnyObject) {
//    showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
//      guard let strongSelf = self else { return }
//      guard let email = email else {
//        strongSelf.showMessagePrompt("email can't be empty")
//        return
//      }
//      strongSelf.showSpinner {
//        // [START get_methods]
//        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
//          // [START_EXCLUDE]
//          strongSelf.hideSpinner {
//            if let error = error {
//              strongSelf.showMessagePrompt(error.localizedDescription)
//              return
//            }
//            strongSelf.showMessagePrompt(methods!.joined(separator: ", "))
//          }
//          // [END_EXCLUDE]
//        }
//        // [END get_methods]
//      }
//    }
//  }

//  @IBAction func didCreateAccount(_ sender: AnyObject) {
//    showTextInputPrompt(withMessage: "Email:") {  [weak self] userPressedOK, email in
//      guard let strongSelf = self else { return }
//      guard let email = email else {
//        strongSelf.showMessagePrompt("email can't be empty")
//        return
//      }
//      strongSelf.showTextInputPrompt(withMessage: "Password:") { userPressedOK, password in
//        guard let password = password else {
//          strongSelf.showMessagePrompt("password can't be empty")
//          return
//        }
//        strongSelf.showSpinner {
//          // [START create_user]
//          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            // [START_EXCLUDE]
//            strongSelf.hideSpinner {
//              guard let user = authResult?.user, error == nil else {
//                strongSelf.showMessagePrompt(error!.localizedDescription)
//                return
//              }
//              print("\(user.email!) created")
//              strongSelf.navigationController?.popViewController(animated: true)
//            }
//            // [END_EXCLUDE]
//          }
//          // [END create_user]
//        }
//      }
//    }
//  }

}
