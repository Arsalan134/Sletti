//
//  Conference.swift
//  Sletti
//
//  Created by Arsalan Iravani on 12.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit

struct Conference {
    let id: String
    var ownerID: String?
    let title: String
    var image: UIImage?
    var imageURL: URL?
    let language: String
    let description: String
    let place: String
    let time: String
    let date: String
    var availableTranslatorsID: [String]?
    
    var dictionary: [String: Any] {
        return ["title": title as String,
                "imageURL": imageURL?.absoluteString ?? "",
                "language": language,
                "description": description,
                "place": place,
                "time": time,
                "date": date,
                "availableTranslatorsID": availableTranslatorsID ?? [],
                "ownerID": ownerID ?? ""
        ]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
    mutating func deleteTranslator(with id: String) {
        if availableTranslatorsID != nil {
            for i in 0 ..< (availableTranslatorsID?.count ?? 0) {
                if id == availableTranslatorsID![i] {
                    availableTranslatorsID?.remove(at: i)
                }
            }
        }
    }
}
