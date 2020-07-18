//
//  ConferenceDetailViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 12.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

class ConferenceDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTitleView: UITextView!
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    var conference: Conference?
    var user: User?
    var isMyEventSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let conference = conference else {
            return
        }
        
        self.downloadUser()
        
        self.imageView.image = conference.image
        self.descriptionTitleView.text = conference.description
        
        self.placeLabel.text = conference.place
        self.dateLabel.text = conference.date
        self.timeLabel.text = conference.time
        
        placeLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true
        timeLabel.adjustsFontSizeToFitWidth = true
        
        self.title = conference.title
        
        setButton()
    }
    
    func setButton() {
        if isMyEventSelected {
            self.joinButton.setTitle("Delete", for: .normal)
        } else {
            if isAvailableForThisConference() {
                self.joinButton.setTitle("Leave", for: .normal)
            } else {
                self.joinButton.setTitle("Join", for: .normal)
            }
        }
    }
    
    func isAvailableForThisConference() -> Bool {
        for id in (conference?.availableTranslatorsID)! {
            if id == Auth.auth().currentUser?.uid {
                return true
            }
        }
        return false
    }
    
    func setAvailableForThisConference(_ bool: Bool) {
        if bool {
            self.joinButton.setTitle("Leave", for: .normal)
        } else {
            self.joinButton.setTitle("Join", for: .normal)
        }
    }
    
    @IBAction func joinSession() {
        downloadUser()
        guard let user = user, user.isTranslator != nil else {return}
        
        if isMyEventSelected {
            Database.database().reference().child("Conferences").child((conference?.id)!).removeValue()
            
            // create Alert View Controller
            let alert = UIAlertController(title: "Message", message: "Successfully deleted!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            let storage = Storage.storage()
            let url = conference?.imageURL?.absoluteString
            let storageRef = storage.reference(forURL: url!)
            
            //Removes image from storage
            storageRef.delete { error in
                if let error = error {
                    alert.message = error.localizedDescription
                    // present Alert View Controller
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            if user.isTranslator! {
                if !isAvailableForThisConference() {
                    conference?.availableTranslatorsID?.append((Auth.auth().currentUser?.uid)!)
                } else {
                    conference?.deleteTranslator(with :(Auth.auth().currentUser?.uid)!)
                }
                let conferenceRef = Database.database().reference().child("Conferences/\(conference?.id ?? "0")")
                conferenceRef.updateChildValues(["availableTranslatorsID": conference?.availableTranslatorsID ?? "0"])
                setAvailableForThisConference(isAvailableForThisConference())
            } else {
                self.performSegue(withIdentifier: "showTranslators", sender: self)
            }
        }
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
                let isTranslator2 = dict["isTranslator"] as? Bool {
                
                self.user = User(name: name, image: nil, password: "", imageURL: URL(string: imageURL), surname: surname, email: email, phone: phone, location: location, gender: gender, age: age, isTranslator: isTranslator2, languages: [], available: nil)
                
                self.user?.isTranslator = isTranslator2
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TranslatorsTableViewController {
            destination.conference = self.conference
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
