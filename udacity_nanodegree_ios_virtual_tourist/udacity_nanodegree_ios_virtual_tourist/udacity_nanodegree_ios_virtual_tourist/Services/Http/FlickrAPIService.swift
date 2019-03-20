//
//  FlickrAPIService.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 26/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
class FlickrAPIService {
    private static let FLICKR_API_KEY = "6f7769c50f91eb3dc4f2857f25ab76e5"
    private static let FLICKR_BASE_URL = "https://api.flickr.com/services/rest/"

    private static let GET_PHOTOS_PARAMETERS=[
        "method" : "flickr.photos.search",
        "api_key" : FLICKR_API_KEY,
        "extras" : "url_m",
        "format" : "json",
        "nojsoncallback" : "1",
        "per_page" : "21",
        "safe_search" : "1"
    ]
    
    typealias GetPhotosResult = (String?,FlickrImageResponse?)->Void
    
    public static func getPhotos(lat:Double,long: Double,page: Int, result: GetPhotosResult?){
        var parameters = FlickrAPIService.GET_PHOTOS_PARAMETERS
        parameters["lat"] = "\(lat)"
        parameters["lon"] = "\(long)"
        parameters["page"] = "\(page)"
        let theUrl = FLICKR_BASE_URL.appendUrlParams(params: parameters)
        print(theUrl)
        let request = URLRequest(url: URL(string: theUrl)!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error")
                result?(error?.localizedDescription,nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                result?("Error when requesting photos",nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let flickrImages = try decoder.decode(FlickrImageResponse.self, from: data!)
                result?(nil,flickrImages)
            } catch let err {
                result?(err.localizedDescription,nil)
            }

        }
        task.resume()
        //var request = URLRequest(url: URL(string: theUrl)!)
    }
}
