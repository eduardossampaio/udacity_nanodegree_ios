//
//  MemeCollectionViewController.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 14/06/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedMemePosition = -1;
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @IBAction func newMemeClicked(_ sender: Any) {
        print("go to create meme screen")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "createMemeViewController") as! CreateMemeViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMemePosition = indexPath.item;
        performSegue(withIdentifier: "detailMeme", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMeme"{
            print("indo para detalhe")
            if let viewController: DetailMemeViewController = segue.destination as? DetailMemeViewController{
                
                viewController.meme = memes[selectedMemePosition]
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell",for:indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        cell.memeImageView.image = meme.originalImage
        return cell
    }
    
    
   
}
