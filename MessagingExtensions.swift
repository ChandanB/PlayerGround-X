//
//  Extensions.swift
//  PlayerGround 3.0
//
//  Created by Chandan Brown on 7/24/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import UIKit

let imageCache = NSCache()


extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

func addConstraintsWithFormat(_ format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
        let key = "v\(index)"
        view.translatesAutoresizingMaskIntoConstraints = false
        viewsDictionary[key] = view
    }

class CustomImageView: UIImageView {
        
        var imageUrlString: String?
        
        func loadImageUsingUrlString(_ urlString: String) {
            
            imageUrlString = urlString
            
            let url = URL(string: urlString)
            
            image = nil
            
            if let imageFromCache = imageCache.object(forKey: urlString) as? UIImage {
                self.image = imageFromCache
                return
            }
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    let imageToCache = UIImage(data: data!)
                    
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache!, forKey: urlString)
                })
                
            }).resume()
        }
        
    }

    

}
