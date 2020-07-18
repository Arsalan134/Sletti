//
//  Helpers.swift
//  Sletti
//
//  Created by Arsalan Iravani on 12.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit

func downloadImage(withURL url: URL, completion: @escaping (_ image: UIImage) -> ()) {
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        // background thread
        var downloadedImage = UIImage()
        
        if let data = data {
            downloadedImage = UIImage(data: data)!
        }
        
        // background thread
        DispatchQueue.main.async {
            // main thread
            completion(downloadedImage)
        }
    }
    // main thread
    dataTask.resume()
}


func downloadImage(withURL url: String, completion: @escaping (_ image: UIImage) -> ()) {
    
    guard let url = URL(string: url) else {return}
    
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
        // background thread
        var downloadedImage = UIImage()
        
        if let data = data {
            downloadedImage = UIImage(data: data)!
        }
        
        // background thread
        DispatchQueue.main.async {
            // main thread
            completion(downloadedImage)
        }
    }
    // main thread
    dataTask.resume()
}

