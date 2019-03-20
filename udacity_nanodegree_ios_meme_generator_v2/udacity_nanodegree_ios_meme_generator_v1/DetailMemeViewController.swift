//
//  DetailMemeViewController.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 14/06/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit

class DetailMemeViewController :UIViewController{
    var meme:Meme? = nil
    
    @IBOutlet weak var memeImage: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        if let meme = self.meme{
            memeImage.image = meme.memedImage
            print("setou meme\(meme)")
        }else{
            print("meme null")
        }
    }
    
}
