//
//  InstragramLoginSuccessViewController.swift
//  EmbededGoogleSignIn
//
//  Created by Amrit on 8/9/17.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import ObjectMapper



class LoginModuleInstragram : Mappable {
    var data : Data?
    required init(map: Map) {
        
    }
    func mapping(map: Map) {
        data <- map["data"]
    }
    
}
class Data : Mappable {
    var id : String?
    var userName : String?
    var profilePicture : String?
    var fullName : String?
    var counts: Counts?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        userName <- map["username"]
        profilePicture <- map["profile_picture"]
        fullName <- map["full_name"]
        counts <- map["counts"]
        
    }
}

class Counts : Mappable {
    
    var media : Int?
    var follows : Int?
    var followedBy : Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        media <- map["media"]
        follows <- map["follows"]
        followedBy <- map["followed_by"]
        
    }
}

