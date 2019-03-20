//
//  FlickrImageResponse.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 26/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
struct FlickrPhotos : Codable {
    var page : Int?
    var pages :Int?
    var perpage :Int?
    var total :String?
    var photo :[FlickrImage]?
}
struct FlickrImageResponse : Codable {
    var photos: FlickrPhotos?
    var stat:String?
}

