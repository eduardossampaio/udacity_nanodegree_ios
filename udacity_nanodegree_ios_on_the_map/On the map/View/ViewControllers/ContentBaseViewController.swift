//
//  ContentBaseViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit
class ContentBaseViewController : UIViewController{
  
    
    func retrieveStudents(result:ParseApiService.StudentsLocationsResult?){
        if( !(StudentDAO.instance.cachedStudents.isEmpty)){
            result?(true,nil,StudentDAO.instance.cachedStudents)
        }
        let sv = UIViewController.displaySpinner(onView: self.view)
        ParseApiService.getStudentsLocations() { succeed,error, students in
            DispatchQueue.main.async {
                UIViewController.removeSpinner(spinner: sv)
            }
            result?(succeed,error,students)
        }
    }
    
    func reloadStudents(result:ParseApiService.StudentsLocationsResult?){
        StudentDAO.instance.cachedStudents=[Student]()
        retrieveStudents(result: result)
    }
    
    func logout(){
        let sv = UIViewController.displaySpinner(onView: self.view)
        UdacityApiService.logoutUdacity() { succeed,error in
            if(succeed){
                DispatchQueue.main.async {
                    UIViewController.removeSpinner(spinner: sv)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func goToNewLocationScreen(){
        performSegue(withIdentifier: "goToNewLocationScreen", sender: nil)
    }
}
