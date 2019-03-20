//
//  ParseApiService.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit
class ParseApiService {
    private static let PARSE_GET_STUDENTS_URL = "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100"
    private static let PARSE_ADD_STUDENT_URL  = "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt/"
    private static let PARSE_UPDATE_STUDENT_URL  = "https://parse.udacity.com/parse/classes/StudentLocation/"
    private static let PARSE_GET_SINGLE_STUDENT_URL = "https://parse.udacity.com/parse/classes/StudentLocation/"
    private static let PARSE_APPLICATION_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let PARSE_REST_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    typealias StudentsLocationsResult = (Bool,String?,[Student]?)->Void
    typealias AddLocationsResult = (Bool,String?)->Void
 
    
    static func getStudentsLocations(theUrl: String,result:@escaping StudentsLocationsResult){
       
        var request = URLRequest(url: URL(string: theUrl)!)
        request.addValue(PARSE_APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                result(false,error?.localizedDescription,nil)
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                result(false,"Error when authenticate",nil)
                return
            }

            let students = parseResult(data!)
            result(true,nil,students)
        }
        task.resume()
    }
    static func getStudentsLocations(result:@escaping StudentsLocationsResult){
        getStudentsLocations(theUrl:PARSE_GET_STUDENTS_URL,result: result)
    }
		
    static func getStudentLocations(id:String,result:@escaping StudentsLocationsResult){
        let whereCause = "{\"uniqueKey\":\"\(id)\"}";
        let formattedWhereCause = whereCause.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = "\(PARSE_GET_SINGLE_STUDENT_URL)?where=\(formattedWhereCause!)"
        getStudentsLocations(theUrl:url,result: result);
    }
    static private func addNewStudentLocation(url:String,method:String,udacityUser:UdacityUser,mediaUrl:String,mapString:String,latitude:Double,longitude:Double, result:AddLocationsResult?){
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(PARSE_APPLICATION_ID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(PARSE_REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod=method;
       
        let jsonEncoder = JSONEncoder()
        let student = Student(objectId: nil, uniqueKey: udacityUser.account.key, firstName: "Eduardo", lastName: "Sampaio", mediaURL: mediaUrl, mapString: mapString, latitude: latitude, longitude: longitude, createdAt: nil, updatedAt: nil)
        var jsonData:Data?=nil
        do {
            jsonData =  try jsonEncoder.encode(student)
        }catch{
            result?(false,"error when make request")
            return
        }
       
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                result?(false,error?.localizedDescription)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                result?(false,"Error when authenticate")
                return
            }
            result?(true,nil)
        }
        task.resume()
    }
    
    static func addNewStudentLocation(udacityUser:UdacityUser,mediaUrl:String,mapString:String,latitude:Double,longitude:Double, result:AddLocationsResult?){
        let url = PARSE_ADD_STUDENT_URL;
        addNewStudentLocation(url: url,method:"POST", udacityUser: udacityUser, mediaUrl: mediaUrl, mapString: mapString, latitude: latitude, longitude: longitude, result: result)
    }
    
    static func updateStudentLocation(objectId:String,udacityUser:UdacityUser,mediaUrl:String,mapString:String,latitude:Double,longitude:Double, result:AddLocationsResult?){
        let url = "\(PARSE_UPDATE_STUDENT_URL)\(objectId)";
        print(url)
        addNewStudentLocation(url: url,method:"PUT", udacityUser: udacityUser, mediaUrl: mediaUrl, mapString: mapString, latitude: latitude, longitude: longitude, result: result)
    }
    
    static private func parseResult(_ responseJson:Data) -> [Student]{
        do {
            let parsedResult = try JSONSerialization.jsonObject(with: responseJson, options: .allowFragments) as! [String:AnyObject]
            let results =  parsedResult["results"] as! [ [String : AnyObject] ]
            
            var students = [Student]()
            for r in results {
                let student = Student(params: r )
                if( (student.firstName?.isEmpty) == false){
                    students.append(student)
                }
            }
           return students
        } catch {
            return [Student]()
        }
    
    }

}
