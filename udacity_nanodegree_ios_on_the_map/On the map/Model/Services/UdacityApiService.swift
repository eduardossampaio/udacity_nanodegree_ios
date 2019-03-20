//
//  UdacityApiService.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 10/07/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit
class UdacityApiService {
    private static let UDACITY_LOGIN_URL = "https://www.udacity.com/api/session"
    private static let UDACITY_USER_URL = "https://www.udacity.com/api/users/"
    
    typealias LoginUdacityResult = (Bool,String?,UdacityUser?)->Void
    typealias LogoutUdacityResult = (Bool,String?)->Void
    
    static func loginToUdacity(username:String,password:String, result:LoginUdacityResult?){
        var request = URLRequest(url: URL(string: UDACITY_LOGIN_URL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        request.httpBody = requestBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                result?(false,error?.localizedDescription,nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                result?(false,"Error when authenticate",nil)
                return
            }
            //response is OK (200)
            let range = Range(5..<data!.count)
            let responseJson = data?.subdata(in: range) /* subset response data! */
            let udacityUser = parseResult(responseJson!)
            getUserData(udacityUser: udacityUser!, result: result)

        }
        task.resume()
    }
    
     static func getUserData(udacityUser:UdacityUser, result:LoginUdacityResult?){
        let url = "\(UDACITY_USER_URL)\(udacityUser.account.key!)"
        var request = URLRequest(url: URL(string: url)!)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                result?(false,error?.localizedDescription,nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                result?(false,"Error when authenticate",nil)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            AppDelegate.sharedInstance?.udacityUser = parseUserData(newData!, udacityUser: udacityUser)
            result?(true,nil,udacityUser)
            
        }
        task.resume()
    }
    
    
    static func logoutUdacity( result:LogoutUdacityResult?){
        var request = URLRequest(url: URL(string: UDACITY_LOGIN_URL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                result?(false,"Error when logint out")
                return
            }
             result?(true,nil)
        }
        task.resume()
    }
    
    static private func parseResult(_ responseJson:Data) -> UdacityUser?{
        var udacityUser = UdacityUser()
        do {
            let parsedResult = try JSONSerialization.jsonObject(with: responseJson, options: .allowFragments) as! [String:AnyObject]
           let account =  parsedResult["account"]!
           let session =  parsedResult["session"]!
            udacityUser.account.key = account["key"] as? String
            udacityUser.account.registered = account["registered"] as? Bool
            udacityUser.session.expiration = session["expiration"] as? String
            udacityUser.session.id = session["id"] as? String
        } catch {
            return nil
        }
        return udacityUser
    }
    
    static private func parseUserData(_ responseJson:Data,udacityUser:UdacityUser) -> UdacityUser?{
        var updatedUdacityUser = UdacityUser()
        do {
            let parsedResult = try JSONSerialization.jsonObject(with: responseJson, options: .allowFragments) as! [String:AnyObject]
            let user = parsedResult["user"] as! [String:AnyObject]
            let firstName =  user["first_name"]!
            let lastName =  user["last_name"]!
            updatedUdacityUser.firstName = firstName as! String
            updatedUdacityUser.lastName = lastName as! String
            updatedUdacityUser.session = udacityUser.session
            updatedUdacityUser.account = udacityUser.account
        } catch {
            return nil
        }
        return updatedUdacityUser
    }
}
