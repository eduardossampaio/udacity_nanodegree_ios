//
//  ViewController.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 25/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import UIKit
import MapKit

class MapPinsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    private var selectedAnnotarion : MKAnnotation? = nil
    
    private var isEditingMode = false
    private var mapCenter: CLLocationCoordinate2D? = nil
    private var selectedPin:Pin? = nil
    
    let pinDatabase = PinDatabase();
    var savedPins = [Pin]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setEditingMode(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mapCenter = UserPreferences.getMapCenter()
        let altitude  = UserPreferences.getMapAltitude()
        mapView.zoomToLocation(location: mapCenter, altitude: altitude)
        fetchPins();
    }
    
    func fetchPins()  {
        if let pins = self.pinDatabase.getPins() {
            self.savedPins = pins
            for pin in pins{
                mapView.addAnnotation(latitude: pin.latitude, longitude: pin.longitude)
            }
        }
    }
    
    @IBAction func onEditClicked(_ sender: Any) {
        isEditingMode = !isEditingMode
        setEditingMode(isEditingMode)
    }
    
    @IBAction func onDeleteClicked(_ sender: Any) {
    }
    
    func setEditingMode(_ isEditing:Bool){
        isEditingMode = isEditing
        if ( isEditing){
            buttonHeightConstraint.constant = 60
        }else{
            buttonHeightConstraint.constant = 0
        }
    }
    
    private func setupViewController(){
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        longPressRecognizer.delaysTouchesBegan = false
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if ( gestureRecognizer.state != .began){
            return
        }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        if ( !mapView.contains(annotation: annotation, inRange:0.02)){
            mapView.addAnnotation(annotation)
            savePin(annotation)
        }
    }
    
    func savePin(_ annotation:MKAnnotation){
        let newPin = pinDatabase.savePin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        savedPins.append(newPin)
    }
    
    func deletePin(_ annotation:MKAnnotation){
        for pin in self.savedPins{
            if ( pin.equals(to: annotation)){
                pinDatabase.deletePin(pin: pin)
            }
        }
        self.savedPins = pinDatabase.getPins() ?? [Pin]()
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotarion = view.annotation
        if ( isEditingMode){
            if let annotation = view.annotation{
                mapView.removeAnnotation(annotation)
                deletePin(annotation)
            }
        }else{
            let position = view.annotation?.coordinate
            self.selectedPin = pinDatabase.getPin(latitude: (position?.latitude)!,longitude: (position?.longitude)!)
            self.performSegue(withIdentifier: "goToGalleryView", sender: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapCenter = mapView.region.center
        let altitude = mapView.camera.altitude
        UserPreferences.saveMapCenter(coordicate: mapCenter)
        UserPreferences.saveMapCenterAltitude(altitude: altitude)
        self.mapCenter = mapCenter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "goToGalleryView"){
            let galleryViewController = segue.destination as! GalleryViewController
            galleryViewController.annotation = self.selectedAnnotarion!
            galleryViewController.pin = self.selectedPin
        }
    }

}

