//
//  UserPreferences.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 26/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import MapKit
class UserPreferences{
    private static let MAP_CENTER_LATITUDE = "MAP_CENTER_LATITUDE"
    private static let MAP_CENTER_LONGITUDE = "MAP_CENTER_LONGITUDE"
    private static let MAP_CENTER_ALTITUDE = "MAP_CENTER_ALTITUDE"
    
    public static func initDefaults(){
        UserDefaults.standard.register(defaults: [
            MAP_CENTER_ALTITUDE: 43372054.769128159,
            MAP_CENTER_LATITUDE: 7.5190780275898694,
            MAP_CENTER_LONGITUDE: -59.80022106453206
            ])
    }
    
    public static func saveMapCenter(coordicate: CLLocationCoordinate2D){
        UserDefaults.standard.set(coordicate.latitude, forKey: MAP_CENTER_LATITUDE)
        UserDefaults.standard.set(coordicate.longitude, forKey: MAP_CENTER_LONGITUDE)
    }
    
    public static func saveMapCenterAltitude(altitude:Double){
        UserDefaults.standard.set(altitude, forKey: MAP_CENTER_ALTITUDE)
    }
    public static func getMapCenter() -> CLLocationCoordinate2D{
        let latitude = UserDefaults.standard.double(forKey: MAP_CENTER_LATITUDE)
        let longitude = UserDefaults.standard.double(forKey: MAP_CENTER_LONGITUDE)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    public static func getMapAltitude() -> Double{
        return UserDefaults.standard.double(forKey: MAP_CENTER_ALTITUDE)
    }
    
    
}
