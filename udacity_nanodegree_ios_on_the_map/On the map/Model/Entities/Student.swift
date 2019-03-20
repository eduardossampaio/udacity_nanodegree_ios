//
//  Student.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
struct Student : Codable {
    var objectId : String? = nil
    var uniqueKey : String? = nil
    var firstName : String? = nil
    var lastName : String? = nil
    var mediaURL: String? = nil
    var mapString : String? = nil
    var latitude : Double? = nil
    var longitude : Double? = nil
    var createdAt : String? = nil
    var updatedAt : String? = nil
    
    init( objectId : String? = nil,uniqueKey : String? = nil,firstName : String? = nil,
          lastName : String? = nil,mediaURL: String? = nil,mapString : String? = nil,
          latitude : Double? = nil,longitude : Double? = nil,createdAt : String? = nil,
          updatedAt : String? = nil){
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.mapString = mapString
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    
    init(params:[String:AnyObject]) {
        objectId = params["objectId"] as? String
        uniqueKey = params["uniqueKey"] as? String
        firstName = params["firstName"] as? String
        lastName = params["lastName"] as? String
        mediaURL = params["mediaURL"] as? String
        mapString = params["mapString"] as? String
        latitude = params["latitude"] as? Double
        longitude = params["longitude"] as? Double
        createdAt = params["createdAt"] as? String
        updatedAt = params["updatedAt"] as? String
        
    }
}
