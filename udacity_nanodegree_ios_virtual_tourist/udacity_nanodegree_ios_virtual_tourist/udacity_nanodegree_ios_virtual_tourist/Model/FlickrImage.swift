//
//  FlickrImage.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 26/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
struct FlickrImage: Codable{
    var id : String?
    var owner  : String?
    var secret : String?
    var server : String?
    var farm : Int?
    var title : String?
    var ispublic : Int?
    var isfriend : Int?
    var isfamily : Int?
    var url_m  : String?
    var height_m : String?
    var width_m : String?
}
