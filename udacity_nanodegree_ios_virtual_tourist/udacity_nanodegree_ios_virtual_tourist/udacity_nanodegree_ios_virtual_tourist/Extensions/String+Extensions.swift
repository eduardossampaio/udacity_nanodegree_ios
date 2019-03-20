//
//  String+Extensions.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 26/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import UIKit
extension String{
    func appendUrlParams(params:[String:String])->String{
        let urlComponents = NSURLComponents(string: self)!
        
        var urlQueryItems = [NSURLQueryItem]()
        
        for (key,param) in params{
            let queryItem = NSURLQueryItem(name: key, value: param);
            urlQueryItems.append(queryItem)
        }
        urlComponents.queryItems = urlQueryItems as [URLQueryItem]
        guard let formatterUrl = urlComponents.url  else{
            return self;
        }
        return formatterUrl.absoluteString
        
    }
}



