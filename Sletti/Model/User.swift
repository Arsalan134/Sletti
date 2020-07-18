//
//  User.swift
//  Sletti
//
//  Created by Arsalan Iravani on 12.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit
struct User {
    var name: String
    var image: UIImage?
    var password: String?
    var imageURL: URL?
    var surname: String
    var email: String
    var phone: String
    var location: String?
    var gender: String
    var age: Int
    var isTranslator: Bool?
    var languages: [String]?
    var available: Bool?
    
    
    var dictionary: [String: Any] {
        return ["name": name as String,
                "surname": surname as String,
                "email": email as String,
                "imageURL": imageURL?.absoluteString ?? "",
                "phone": phone as String,
                "isTranslator": isTranslator ?? false,
                "languages": languages ?? [],
                "gender": gender as String,
                "age": age as Int,
                "location": location ?? "no location",
                "available": available ?? false
        ]
    }

    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
}

