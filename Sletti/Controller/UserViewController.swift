//
//  UserViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 10.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        downloadUser()
    }
    
    func downloadUser() {
        let ref = Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid ?? "0")")
        
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any],
                let name = dict["name"] as? String,
                let surname = dict["surname"] as? String,
                let imageURL = dict["imageURL"] as? String,
                let email = dict["email"] as? String,
                let phone = dict["phone"] as? String,
                let location = dict["location"] as? String,
                let gender = dict["gender"] as? String,
                let age = dict["age"] as? Int,
                let isTranslator = dict["isTranslator"] as? Bool
//                let languages = dict["languages"] as? [String],
//                let available = dict["available"] as? Bool,
            {
                
                var user = User(name: name, image: nil, password: "", imageURL: URL(string: imageURL), surname: surname, email: email, phone: phone, location: location, gender: gender, age: age, isTranslator: isTranslator, languages: [], available: false)
                
                self.nameLabel.text = user.name
                self.surnameLabel.text = user.surname
                self.emailLabel.text = user.email
                self.phoneLabel.text = user.phone
                
                if user.imageURL != nil {
                    downloadImage(withURL: user.imageURL!, completion: { (image) in
                        user.image = image
                        self.profileImageView.image = image
                        self.activityIndicator.stopAnimating()
                    })
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func logoutPressed() {
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "showWelcome", sender: self)
    }
    
}
