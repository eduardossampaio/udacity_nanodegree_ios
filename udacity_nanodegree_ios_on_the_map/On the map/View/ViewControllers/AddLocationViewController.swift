//
//  AddLocationViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 12/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit
import MapKit
class AddLocationViewController : UIViewController{
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaUrlTextField: UITextField!
    var locationToPreview:MKMapItem? = nil
    var mediaUrl:String? = nil

    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onAddButtonPressed(_ sender: Any) {
        guard let locationToSerch = locationTextField.text,!(locationToSerch.isEmpty) else{
            displayError(error: "Please insert location")
            return
        }
        guard let mediaUrl = mediaUrlTextField.text,!(mediaUrl.isEmpty) else{
            displayError(error: "Please insert media URL")
            return
        }
        self.mediaUrl = mediaUrl;
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationToSerch
        let search = MKLocalSearch(request: request)
        let sv = UIViewController.displaySpinner(onView: self.view)
        search.start { response, _ in
            UIViewController.removeSpinner(spinner: sv)
            guard let response = response else {
                self.displayError(error: "Location not found. Try again")
                return
            }
            self.locationToPreview = response.mapItems[0]
            self.performSegue(withIdentifier: "goToSavePinScreen", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSavePinScreen"{
            let destinationVC = segue.destination as! SaveLocationViewController
            destinationVC.locationToPreview = self.locationToPreview
            destinationVC.mediaURL=self.mediaUrl
        }
    }
    
    
}
