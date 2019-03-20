//
//  ViewController.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 09/07/18.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if isInputValid() {
            updateViews(enabled: false)
            doLogin()
        }
    }
    
    @IBAction func onSignInClicked(_ sender: Any) {
        Utils.openUrl(url: Constants.Udacity.SignInSiteUrl)
    }
    private func isInputValid()->Bool{
        return !(loginTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
    }
    private func updateViews(enabled:Bool){
        loginButton.alpha = enabled ? 1 : 0.4
        loginButton.isEnabled = enabled
        loginTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
    }
    
    private func doLogin(){
       
        UdacityApiService.loginToUdacity(username: loginTextField.text!, password: passwordTextField.text!) { succeed,error, udacityUser in
            DispatchQueue.main.async {
                self.updateViews(enabled: true)
                if succeed {
                   self.performSegue(withIdentifier: "goToMapScreen", sender: nil)
                }else{
                    self.displayError(error: error!)
                }
            }
        }
    }
}

