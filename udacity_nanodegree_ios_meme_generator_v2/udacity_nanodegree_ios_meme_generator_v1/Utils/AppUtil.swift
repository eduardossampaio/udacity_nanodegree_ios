//
//  AppUtil.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 16/05/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit
class AppUtil {
    
   static func pickImageFromGallery(_ viewController:UIViewController, _ imagePickerDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
      pickImage(viewController,.photoLibrary,imagePickerDelegate)
    }
    
   static func pickImageFromCamera(_ viewController:UIViewController, _ imagePickerDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        pickImage(viewController,.camera,imagePickerDelegate)
    }
    
    static private func pickImage(_ viewController:UIViewController,_ sourceType: UIImagePickerControllerSourceType, _ imagePickerDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate){
        let pickerController = UIImagePickerController()
        pickerController.delegate = imagePickerDelegate
        pickerController.sourceType = sourceType
        viewController.present(pickerController, animated: true, completion: nil)
    }
    
}
