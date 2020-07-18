//
//  TranslatorsTableViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 14.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

class TranslatorsTableViewController: UITableViewController {
    
    var conference: Conference?
    var translators: [User] = []
    
    var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadTranslators()
    }
    
    func downloadTranslators() {
        let translatorsRef = Database.database().reference().child("Users")
        
        translatorsRef.observe(.value) { (snapshot) in
            self.translators.removeAll()
            
            for translator in snapshot.children {
                if let childSnapshot = translator as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let surname = dict["surname"] as? String,
                    let imageURL = dict["imageURL"] as? String,
                    let email = dict["email"] as? String,
                    let phone = dict["phone"] as? String,
                    let location = dict["location"] as? String,
                    let gender = dict["gender"] as? String,
                    let age = dict["age"] as? Int,
                    let isTranslator = dict["isTranslator"] as? Bool {
                    
                    if self.isAvailableTranslator(withID: childSnapshot.key) {
                        var translator = User(name: name, image: nil, password: nil, imageURL: URL(string: imageURL), surname: surname, email: email, phone: phone, location: location, gender: gender, age: age, isTranslator: isTranslator, languages: nil, available: nil)
                        
                        if let languages = dict["languages"] as? [String],
                            let available = dict["available"] as? Bool {
                            translator.languages = languages
                            translator.available = available
                        }
                        
                        self.translators.append(translator)
                    } else {
                        continue
                    }
                    
                    downloadImage(withURL: imageURL, completion: { (image) in
                        for i in 0 ..< self.translators.count {
                            if self.translators[i].imageURL?.absoluteString == imageURL {
                                self.translators[i].image = image
                                self.tableView.reloadData()
                            }
                        }
                    })
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showCall", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.callFromUserID = Auth.auth().currentUser?.displayName 
            destination.callToUserID = translators[selectedIndex].email
        }
    }
    
    func isAvailableTranslator(withID tid: String) -> Bool{
        guard conference?.availableTranslatorsID != nil else { return false }
        
        for id in (conference?.availableTranslatorsID)! {
            if tid == id {
                return true
            }
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return translators.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translatorCell", for: indexPath) as! TranslatorCell
        
        cell.profileImageView.image = translators[indexPath.row].image
        cell.fullnameLabel.text = translators[indexPath.row].name + " " + translators[indexPath.row].surname
        cell.languageLabel.text = String.uppercased(flatten(array: translators[indexPath.row].languages ?? [""]))()
        cell.locationLabel.text = translators[indexPath.row].location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
