//
//  MapViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 11/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class MapViewCOntroller :ContentBaseViewController,MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func onLogoutClicked(_ sender: Any) {
        super.logout()
    }

    @IBAction func onAddPressed(_ sender: Any) {
        super.goToNewLocationScreen()
    }
    @IBAction func onRefreshPressed(_ sender: Any) {
        super.reloadStudents() { succeed,error, students in
            if succeed {
                DispatchQueue.main.async {
                   self.displayPins(students: students!)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveStudents()
    }
    func retrieveStudents(){
        super.retrieveStudents() { succeed,error, students in
            if succeed {
                DispatchQueue.main.async {
                    self.displayPins(students: students!)
                }
            }
        }
    }
    
    func displayPins(students:[Student]){
        for student in students{
            let location = CLLocationCoordinate2D(latitude: student.latitude!,
                                                  longitude: student.longitude!)
            
            // 2
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            //3
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = String(describing: "\(student.firstName!) \(student.lastName!)")
            annotation.subtitle = student.mediaURL
            mapView.addAnnotation(annotation)
        }
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let url = view.annotation?.subtitle else{
            return
        }
        Utils.openUrl(url: url!)
    }
   
}
