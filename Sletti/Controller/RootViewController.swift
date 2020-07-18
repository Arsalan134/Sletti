//
//  RootViewController.swift
//  Sletti
//
//  Created by Arsalan Iravani on 14.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

class RootViewController: UIViewController {
    
    var isTranslator: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showScreen()
    }
    
    func showScreen() {
        if Auth.auth().currentUser != nil {
            guard let isTranslator = isTranslator else {return}
            
            if !isTranslator {
                performSegue(withIdentifier: "showMain", sender: self)
            } else if isTranslator {
                performSegue(withIdentifier: "showTranslator", sender: self)
            }
        } else {
            performSegue(withIdentifier: "showWelcome", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InitTranslator {
            destination.callFromUserID = Auth.auth().currentUser?.email ?? ""
        }
    }
    
    func downloadUser() {
        let userRef = Database.database().reference().child("Users/\(Auth.auth().currentUser?.uid ?? "0")")

        userRef.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any],
                let isTranslator2 = dict["isTranslator"] as? Bool {
                self.isTranslator = isTranslator2
                self.showScreen()
            }
        }
    }
    
}
