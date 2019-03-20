//
//  Utils.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit
class Utils{
    
    static func openUrl(url:String?){
       
        guard var url = url else{
            return
        }
        if (!url.hasPrefix("http")){
            url = "http://\(url)"
        }
        guard let urlToOpen = URL(string: url) else{
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlToOpen)
        }
    }
}
