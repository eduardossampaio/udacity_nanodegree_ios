//
//  SaveLocationViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 15/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import MapKit
import UIKit

class SaveLocationViewController : UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationToPreview:MKMapItem? = nil
    var mediaURL:String? = nil
    private var sv:UIView? = nil
    private var savedLocation:Student? = nil
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let locationToPreview = self.locationToPreview{
            let annotation = MKPointAnnotation()           
            annotation.coordinate = locationToPreview.placemark.coordinate
            annotation.title = locationToPreview.name
            annotation.subtitle=mediaURL
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    @IBAction func onCancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let id = AppDelegate.sharedInstance?.udacityUser?.account.key
        self.sv = UIViewController.displaySpinner(onView: self.view)
        ParseApiService.getStudentLocations(id: id!){ succedd,error,students in
            
            if(!succedd){
                self.displayError(error: error!)
                UIViewController.removeSpinner(spinner: self.sv!)
                return
            }
            
            guard let studentLocations = students , self.alreadyHaveSavedLocation(studentLocations: studentLocations) else {
                self.addNewStudentLocation()
                return
            }
            UIViewController.removeSpinner(spinner: self.sv!)
           
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "On the map", message: "Location already exists, override?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.updateStudentLocation()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    private func alreadyHaveSavedLocation(studentLocations:[Student]) -> Bool{
        var found = false
        for studentLocation in studentLocations{
            if(studentLocation.latitude == locationToPreview?.placemark.coordinate.latitude && studentLocation.longitude == locationToPreview?.placemark.coordinate.longitude){
                savedLocation = studentLocation
                found = true
            }
        }
        return found
    }
    private func addNewStudentLocation(){
        ParseApiService.addNewStudentLocation(udacityUser: (AppDelegate.sharedInstance?.udacityUser)!, mediaUrl: self.mediaURL!, mapString: (self.locationToPreview?.name)!, latitude: (locationToPreview?.placemark.coordinate.latitude)!, longitude: (locationToPreview?.placemark.coordinate.longitude)!) { succeed,error in
            UIViewController.removeSpinner(spinner: self.sv!)
            guard succeed else{
                self.displayError(error: error!)
                return
            }
            self.showSuccessMessage("Location successfuly added");
        }
    }
    
    private func updateStudentLocation(){
        self.sv = UIViewController.displaySpinner(onView: self.view)
        ParseApiService.updateStudentLocation(objectId: (savedLocation?.objectId)!,udacityUser: (AppDelegate.sharedInstance?.udacityUser)!, mediaUrl: self.mediaURL!, mapString: (self.locationToPreview?.name)!, latitude: (locationToPreview?.placemark.coordinate.latitude)!, longitude: (locationToPreview?.placemark.coordinate.longitude)!) { succeed,error in
            UIViewController.removeSpinner(spinner: self.sv!)
            guard succeed else{
                self.displayError(error: error!)
                return
            }
            self.showSuccessMessage("Location successfuly updated");
        }
    }
    
    private func showSuccessMessage(_ message:String){
        let alert = UIAlertController(title: "On the map", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
   
}
