//
//  Pin+Extensions.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 27/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Pin {
    func equals(to annotation:MKAnnotation) -> Bool{
        return
            (latitude == annotation.coordinate.latitude &&
                longitude == annotation.coordinate.longitude )
    }
    
    func increaseAlbumNumber(){
        var currentAlbumPage = self.albumPage?.intValue ?? 1
        currentAlbumPage += 1
        self.albumPage = NSDecimalNumber(value: currentAlbumPage)
        if(currentAlbumPage > (self.albumPageNumber?.intValue)!){
            albumPage = NSDecimalNumber(value: 1)
        }
    }
}
