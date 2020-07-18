//
//  Functions.swift
//  Sletti
//
//  Created by Arsalan Iravani on 14.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import Foundation
import Firebase

func flatten(array: [String]) -> String {
    return array.joined(separator: ", ")
}

func addToDatabase(user: User, completion: @escaping ((_ success: Bool) -> ())) {
    guard let userID = Auth.auth().currentUser?.uid else { return }
    let usersRef = Database.database().reference().child("/Users/\(userID)")
    usersRef.setValue(user.dictionary) { (error, ref) in
        completion(error == nil)
    }
}

func addToDatabase(conference: Conference, completion: @escaping ((_ success: Bool) -> ())) {
    let conferencesRef = Database.database().reference().child("Conferences").childByAutoId()
    conferencesRef.setValue(conference.dictionary) { (error, ref) in
        completion(error == nil)
    }
}

func uploadImage(_ image: UIImage, isConference: Bool = false, completion: @escaping ((_ url: URL?)->())) {
    let storageRef = isConference ? Storage.storage().reference().child("Conferences/\(Database.database().reference().childByAutoId())") : Storage.storage().reference().child("Users/\(Database.database().reference().childByAutoId())")
    
    guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    storageRef.putData(imageData, metadata: metaData) { metaData, error in
        if error == nil, metaData != nil {
            print(metaData ?? " ")
            if let url = metaData?.downloadURL() {
                completion(url)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
