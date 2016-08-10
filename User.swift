//
//  Users.swift
//  PlayerGround 3.0
//
//  Created by Chandan Brown on 7/24/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import Firebase
import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    init(id: String?, name: String?, email: String?, profileImageUrl: String?) {
    self.id = id
    self.name = name
    self.email = email
    self.profileImageUrl = profileImageUrl
    }
}
