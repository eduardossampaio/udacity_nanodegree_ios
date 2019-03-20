//
//  MapView+Extenstions.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 25/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import MapKit
extension MKMapView{
    
    func contains(annotation: MKAnnotation,inRange range:Double = 0) -> Bool {
        for localAnnotation in annotations{

            let latitude = localAnnotation.coordinate.latitude
            let longitude = localAnnotation.coordinate.longitude
            if (annotation.coordinate.latitude-range ..< annotation.coordinate.latitude+range).contains(latitude) &&
                (annotation.coordinate.longitude-range ..< annotation.coordinate.longitude+range).contains(longitude) {
                return true
            }
        }
        return false
    }
    
    func addAnnotation(latitude:Double,longitude:Double){
        let annotation = MKPointAnnotation()
        annotation.coordinate.longitude = longitude
        annotation.coordinate.latitude = latitude
        addAnnotation(annotation)
    }
    
    func zoomToLocation(location:CLLocationCoordinate2D,altitude:Double){
        var region = MKCoordinateRegion()
        region.center.latitude = location.latitude
        region.center.longitude = location.longitude
        self.setRegion(region, animated: true)
        self.camera.altitude = altitude
        self.isZoomEnabled = true
    }
}
