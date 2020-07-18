//
//  MainViewController.swift
//  
//
//  Created by Arsalan Iravani on 09.04.2018.
//

import UIKit
import Firebase

var conferences: [Conference] = []

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex = -1
    var tabIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.tabBarController?.selectedIndex == 3 {
            self.title = "My Events"
        } else {
            self.title = "Events"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabIndex = (self.tabBarController?.selectedIndex)!
        
        conferences.removeAll()
        self.collectionView.reloadData()
        
        self.downloadConferences()
    }
    
    func downloadConferences() {
        let conferenceRef = Database.database().reference().child("Conferences")
        
        conferenceRef.observe(.value) { (snapshot) in
            conferences.removeAll()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let title = dict["title"] as? String,
                    let imageURLString = dict["imageURL"] as? String,
                    let language = dict["language"] as? String,
                    let description = dict["description"] as? String,
                    let place = dict["place"] as? String,
                    let time = dict["time"] as? String,
                    let date = dict["date"] as? String {
                    
                    var conference = Conference(id: childSnapshot.key, ownerID: nil, title: title, image: UIImage(), imageURL: URL(string: imageURLString), language: language, description: description, place: place, time: time, date: date, availableTranslatorsID: [])
                    
                    if let availableTranslatorsID = dict["availableTranslatorsID"] as? [String] {
                        conference.availableTranslatorsID = availableTranslatorsID
                    }
                    
                    if let ownerID = dict["ownerID"] as? String {
                        conference.ownerID = ownerID
                    }
                    
                    if self.tabIndex == 3 {
                        if conference.ownerID != Auth.auth().currentUser?.uid || conference.ownerID == nil {
                            continue
                        }
                    }
                    
                    conferences.append(conference)
                    
                    self.collectionView.reloadData()
                    
                    guard let imageURL = URL(string: imageURLString) else {return}
                    
                    downloadImage(withURL: imageURL, completion: { (image) in
                        for i in 0 ..< conferences.count {
                            if conferences[i].imageURL?.absoluteString == imageURL.absoluteString {
                                conferences[i].image = image
                                self.collectionView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
}


extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conferences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCell
        
        cell.imageView.image = conferences[indexPath.row].image
        cell.titleLabel.text = conferences[indexPath.row].title
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showConferenceDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConferenceDetailViewController {
            destination.conference = conferences[selectedIndex]
            destination.isMyEventSelected = tabIndex == 3
        }
    }
}










