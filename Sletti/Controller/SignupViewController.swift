//
//  SignupViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 10.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

let authStatus = CLLocationManager.authorizationStatus()
let inUse = CLAuthorizationStatus.authorizedWhenInUse
let always = CLAuthorizationStatus.authorizedAlways

class SignupViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    var userOBJ: User?
    var image2: UIImage?
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var isTranslatorSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var signupButton: UIButtonX!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSignupButton(enabled: false)
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2.0
        activityIndicator.center = signupButton.center
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @IBAction func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanging() {
//        print("editing")
        let email = emailTextField.text
        let password = passwordTextField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setSignupButton(enabled: formFilled)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            nameTextField.resignFirstResponder()
            surnameTextField.becomeFirstResponder()
        case surnameTextField:
            surnameTextField.resignFirstResponder()
            ageTextField.becomeFirstResponder()
        case ageTextField:
            ageTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            phoneTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func signupPressed() {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let surname = surnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let age = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        guard let image = profileImageButton.backgroundImage(for: .normal) else { return }
        
        guard let ageInt: Int = Int(age) else {return}
        
        userOBJ = User(name: name, image: nil, password: password, imageURL: nil, surname: surname, email: email, phone: phone, location: "Azerbaijan", gender: "male", age: ageInt, isTranslator: false, languages: [], available: false)

        if isTranslatorSegmentedControl.selectedSegmentIndex == 1 {
            performSegue(withIdentifier: "showTranslatorSignup", sender: self)
            return
        }
        
        setSignupButton(enabled: false)
        signupButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        //save to database
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                
                print("User created!")
                
                // 1. Upload the profile image to Firebase Storage
                uploadImage(image, completion: { (url) in
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = name + " " + surname
                        changeRequest?.photoURL = url
                        
                        self.userOBJ?.imageURL = url
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                guard self.userOBJ != nil else {return}
                                addToDatabase(user: self.userOBJ!, completion: { (success) in
                                    if success {
                                        self.performSegue(withIdentifier: "showMain", sender: self)
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
                    } else {
                        // Error unable to upload profile image
                        print("Error 4:", error ?? "")
                        self.presentAlert(with: error!)
                        self.reset()
                    }
                })
            } else {
                print("Error 3:", error ?? "")
                self.presentAlert(with: error!)
                self.reset()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TranslatorSignupViewController {
            userOBJ?.image = image2
            destination.userOBJ = self.userOBJ
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
        textFieldChanging()
    }
    
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageButton.setBackgroundImage(pickedImage, for: .normal)
            userOBJ?.image = pickedImage
            image2 = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
