//
//  DefaultTextViewDelegate.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 10/07/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit

class DefaultTextViewDelegate: UIViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
