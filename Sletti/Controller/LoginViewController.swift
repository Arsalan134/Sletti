//
//  LoginViewController.swift
//  
//
//  Created by Arsalan Iravani on 10.04.2018.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = loginButton.center
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func setLoginButton(enabled:Bool) {
        if enabled {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginPressed() {
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        setLoginButton(enabled: false)
        loginButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if error == nil && user != nil {
                self.downloadUser()
            } else {
                self.presentAlert(with: error!)
                self.reset()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.callFromUserID = Auth.auth().currentUser?.email ?? ""
        }
        if let destination = segue.destination as? InitTranslator {
            destination.callFromUserID = Auth.auth().currentUser?.email ?? ""
        }
    }
    
    func reset() {
        self.activityIndicator.stopAnimating()
        self.loginButton.setTitle("Login", for: .normal)
        setLoginButton(enabled: true)
    }
    
    func presentAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func downloadUser() {
        let usersRef = Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid ?? "0")")
        
        usersRef.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any],
                let isTranslator = dict["isTranslator"] as? Int {
                
                if isTranslator == 1 {
                    self.performSegue(withIdentifier: "showTranslator", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showMain", sender: self)
                }
            }
        }
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
