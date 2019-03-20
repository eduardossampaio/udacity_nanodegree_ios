//
//  DefaultTextFieldDelegate.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 18/05/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation
import UIKit
class DefaultTextFieldDelegate :NSObject, UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
