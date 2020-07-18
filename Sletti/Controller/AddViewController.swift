//
//  AddViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 09.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addEventButton: UIButton!
    
    var conference: Conference?
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = #imageLiteral(resourceName: "Group 163").withRenderingMode(.alwaysOriginal)
        self.tabBarItem.selectedImage = #imageLiteral(resourceName: "Group 163").withRenderingMode(.alwaysOriginal)
        
//        setAddEventButton(enabled: false)
        
        addEventButton.layer.cornerRadius = addEventButton.frame.height / 2.0
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.center = addEventButton.center
    }
    
    
    
    @IBAction func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func setAddEventButton(enabled:Bool) {
        if enabled {
            addEventButton.alpha = 1.0
            addEventButton.isEnabled = true
        } else {
            addEventButton.alpha = 0.5
            addEventButton.isEnabled = false
        }
    }
    
    func clear() {
        reset()
        
        titleTextField.text = nil
        dateTextField.text = nil
        placeTextField.text = nil
        timeTextField.text = nil
        descriptionTextView.text = nil
        addPhotoButton.setBackgroundImage(nil, for: .normal)
    }
    
    @IBAction func addEventPressed() {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let date = dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let place = placeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let time = timeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        let languageIndex = languageSegmentedControl.selectedSegmentIndex
        guard let description = descriptionTextView.text else {return}
        guard let image = addPhotoButton.backgroundImage(for: .normal) else { return }
        
        setAddEventButton(enabled: false)
        addEventButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        var language: String = ""
        
        switch languageIndex {
        case 0:
            language = "en"
        case 1:
            language = "ru"
        case 2:
            language = "az"
        default: break
        }
        
        conference = Conference(id: "asd", ownerID: Auth.auth().currentUser?.uid, title: title, image: nil, imageURL: nil, language: language, description: description, place: place, time: time, date: date, availableTranslatorsID: nil)
        
        
        // 1. Upload the profile image to Firebase Storage
        uploadImage(image, isConference: true, completion: { (url) in
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                
                self.conference?.imageURL = url
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User display name changed!")
                        
                        guard self.conference != nil else { return }
                        addToDatabase(conference: self.conference!, completion: { (success) in
                            if success {
                                self.presentAlert(with: "Successfully created an event 🎉")
                                self.clear()
                                self.tabBarController?.selectedIndex = 0
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
        })
    }
    
    func presentAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(with message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reset() {
        self.activityIndicator.stopAnimating()
        self.addEventButton.setTitle("Add event", for: .normal)
        setAddEventButton(enabled: true)
    }
    
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.addPhotoButton.setBackgroundImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}


