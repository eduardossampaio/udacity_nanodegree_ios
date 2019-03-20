//
//  GalleryViewController.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 25/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import UIKit
import MapKit
class GalleryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    struct CellData : Equatable{
        var photoUrl : String?
        var photo: Photo?
        
        init(photoUrl:String) {
            self.photoUrl = photoUrl
        }
        
        init(photo:Photo?) {
            self.photo = photo
        }
        
        static func ==(lhs:CellData, rhs:CellData) -> Bool { // Implement Equatable
            return
                lhs.photo == rhs.photo &&
                    lhs.photoUrl == rhs.photoUrl
        }
    }
  
    
    private var photoCells = [CellData?]()
    private var cellsToDelete = [CellData?]()
    private var isInDeleteMode = false
    
    let pinDatabase = PinDatabase()
    var pin:Pin? = nil

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",for: indexPath) as! ImageCustomCollectionCellView
        cell.loadingView.isHidden = false;
        cell.contentImage.image = nil
        if let photoCell = photoCells[indexPath.item]{
            if let photoUrl = photoCell.photoUrl{
                fetchFromUrl(pin:pin!,photoUrl:photoUrl,cell:cell,indexPath: indexPath)
            }
            if let photo = photoCell.photo{
                setLocalImage(photoData:photo.imageData!,cell:cell,indexPath: indexPath)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataCell = photoCells[indexPath.item]
        let collectionCell = collectionView.cellForItem(at: indexPath)
        if(cellsToDelete.contains(dataCell)){
            collectionCell?.alpha = 1
            let indexToRemove = cellsToDelete.index(of: dataCell)
            cellsToDelete.remove(at: indexToRemove!)
        }else{
            collectionCell?.alpha = 0.5
            cellsToDelete.append(dataCell)
        }
        self.isInDeleteMode = cellsToDelete.count > 0
        if(self.isInDeleteMode){
            self.actionButton.setTitle("Delete selected",for:.normal)
        }else{
            self.actionButton.setTitle("New Collection",for:.normal)
        }
        
    }


    private func fetchFromUrl(pin:Pin,photoUrl:String,cell:ImageCustomCollectionCellView,indexPath: IndexPath){
        if let url = URL(string: photoUrl){
            cell.contentImage.downloadedFrom(url:url) { (imageData) in
                cell.loadingView.isHidden = true
                self.pinDatabase.addPhotoToPin(pin: pin, url: photoUrl, imageData: imageData)
            }
        }
    }

    private func setLocalImage(photoData:Data,cell:ImageCustomCollectionCellView,indexPath: IndexPath){
        cell.loadingView.isHidden = true
        cell.contentImage.image = UIImage(data: photoData)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var mapView: MKMapView!
    var annotation:MKAnnotation? = nil

    @IBOutlet weak var noPhotoLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func newCollectionClicked(_ sender: Any) {
        if(isInDeleteMode){
            deleteSelected()
        }else{
            generateNewCollection()
        }
        
    }
    private func generateNewCollection(){
        if let pin = self.pin{
            photoCells = [CellData]()
            collectionView.reloadData()
            pinDatabase.clearPinPhotos(pin: pin)
            pin.increaseAlbumNumber()
            fetchPhotosFromFlickr()
        }
    }
    private func deleteSelected(){
        for cell in cellsToDelete{
            if let photo = cell?.photo{
                pinDatabase.deletePhoto(pin: self.pin!, photo: photo)
            }
        }
        cellsToDelete.removeAll()
        reloadByPin(pin: self.pin)
    }
    private func fetchPhotosFromFlickr(){
        if let lat = annotation?.coordinate.latitude, let long = annotation?.coordinate.longitude{
            let page = pin?.albumPage?.intValue ?? 1
            FlickrAPIService.getPhotos(lat: lat, long: long,page: page){ (error, result) in
                guard error == nil else{
                    return
                }
                if let flickrImages = result?.photos?.photo{
                    if ( flickrImages.count == 0 ){
                        self.showMessageNoPhotos()
                    }else{
                        self.hideMessageNoPhotos()
                    }
                    for flickImage in flickrImages{
                        if let photoUrl = flickImage.url_m{
                            self.photoCells.append(CellData(photoUrl: photoUrl))
                        }
                    }
                }
                let page = result?.photos?.page ?? 1
                let pagesNumber = result?.photos?.pages ?? 1
                self.pin?.albumPageNumber = NSDecimalNumber(value: pagesNumber)
                self.pin?.albumPage = NSDecimalNumber(value: page)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    private func showMessageNoPhotos(){
        DispatchQueue.main.async {
            self.noPhotoLabel.isHidden = false
        }
    }
    private func hideMessageNoPhotos(){
        DispatchQueue.main.async {
            self.noPhotoLabel.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        noPhotoLabel.isHidden = true
        if let annotation = self.annotation{
            mapView.addAnnotation(annotation)
            let position = annotation.coordinate
            let altitude = UserPreferences.getMapAltitude()
            mapView.zoomToLocation(location: position, altitude: altitude)
            
            reloadByPin(pin: self.pin)
        }
    }
    func reloadByPin(pin:Pin?){
        self.photoCells.removeAll()
        if let pin = self.pin{
            if pin.photos?.count == 0{
                fetchPhotosFromFlickr()
            }else{
                setLocalPhotosInCollection()
            }
        }
    }
    func setLocalPhotosInCollection(){
        self.photoCells.removeAll()
        for object in (pin?.photos)!{
            let photo = object as! Photo
            self.photoCells.append(CellData(photo:photo))
        }
        collectionView.reloadData()
    }
    
    
}
