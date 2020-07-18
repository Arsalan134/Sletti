//
//  TranslatorSignupViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 14.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

class TranslatorSignupViewController: UIViewController {
    
    @IBOutlet weak var russianSwitch: UISwitch!
    @IBOutlet weak var azeriSwitch: UISwitch!
    @IBOutlet weak var englishSwitch: UISwitch!
    
    @IBOutlet weak var signupButton: UIButtonX!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userOBJ: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupPressed() {
        setSignupButton(enabled: false)
        signupButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        guard let userOBJ = userOBJ else {return}
        guard let password = userOBJ.password else {return}
        
        Auth.auth().createUser(withEmail: userOBJ.email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                // 1. Upload the profile image to Firebase Storage
                if userOBJ.image != nil {
                    uploadImage( userOBJ.image!, completion: { (url) in
                        if url != nil {
                            self.saveUser(with: url)
                        } else {
                            // Error unable to upload profile image
                            print("Error 4:", error ?? "")
                            self.presentAlert(with: error!)
                            self.reset()
                        }
                    })
                } else {
                    self.saveUser(with: nil)
                }
            } else {
                self.presentAlert(with: error!)
                self.reset()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InitTranslator {
            destination.callFromUserID = Auth.auth().currentUser?.email ?? ""
        }
    }
    
    func saveUser(with url: URL?) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = (userOBJ?.name ?? "") + " " + (userOBJ?.surname ?? "")

        if let url = url {
            changeRequest?.photoURL = url
            self.userOBJ?.imageURL = url
        }
        
        userOBJ?.isTranslator = true
        userOBJ?.available = true
        
        if russianSwitch.isOn {
            userOBJ?.languages?.append("ru")
        }
        
        if azeriSwitch.isOn {
            userOBJ?.languages?.append("az")
        }
        
        if englishSwitch.isOn {
            userOBJ?.languages?.append("en")
        }

        changeRequest?.commitChanges { error in
            if error == nil {
                print("User display name changed!")

                guard let user = self.userOBJ else {return}
                
                addToDatabase(user: user, completion: { (success) in
                    if success {
                        self.performSegue(withIdentifier: "showTranslator", sender: self)
                    } else {
                        print("Error 2:", error ?? "")
                        self.presentAlert(with: error!)
                        self.reset()
                    }
                })
            } else {
                print("Error 1:", error ?? "")
                self.presentAlert(with: error!)
                self.reset()
            }
        }
    }
    
    func presentAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reset() {
        self.activityIndicator.stopAnimating()
        self.signupButton.setTitle("Sign up", for: .normal)
    }
    
    func setSignupButton(enabled:Bool) {
        if enabled {
            signupButton.alpha = 1.0
            signupButton.shadowOpacity = 0.7
            signupButton.isEnabled = true
        } else {
            signupButton.alpha = 0.5
            signupButton.shadowOpacity = 0.3
            signupButton.isEnabled = false
        }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
