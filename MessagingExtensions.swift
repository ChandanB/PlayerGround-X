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
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}

func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerate() {
        let key = "v\(index)"
        view.translatesAutoresizingMaskIntoConstraints = false
        viewsDictionary[key] = view
    }

class CustomImageView: UIImageView {
        
        var imageUrlString: String?
        
        func loadImageUsingUrlString(urlString: String) {
            
            imageUrlString = urlString
            
            let url = NSURL(string: urlString)
            
            image = nil
            
            if let imageFromCache = imageCache.objectForKey(urlString) as? UIImage {
                self.image = imageFromCache
                return
            }
            
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, respones, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
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