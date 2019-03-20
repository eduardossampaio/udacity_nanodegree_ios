//
//  ViewController.swift
//  udacity_nanodegree_ios_meme_generator_v1
//
//  Created by Eduardo Soares Sampaio on 13/05/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    private var originalImage:UIImage?
    private var memedImage:UIImage?

    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue:  UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTextField(topTextField)
        setupTextField(bottomTextField)
    }
    
    private func setupTextField(_ textField:UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(keyboardWillDismiss(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isEditing){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillDismiss(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickImageFromGallery(_ sender: Any) {
       AppUtil.pickImageFromGallery(self,self)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        AppUtil.pickImageFromCamera(self,self)
    }
    @IBAction func shareButtonPressed(_ sender: Any){
        if(self.sourceImage.image == nil){
            return
        }
        self.memedImage = generateMemedImage()
        let imageToShare = [  memedImage! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
           self.saveMemeOnCompletion(completed)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func saveMemeOnCompletion(_ completed: Bool) -> Void {
        if (completed){
            saveMeme()
        }
    }
    
    func resetState(){
        sourceImage.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    func generateMemedImage() -> UIImage {
        
        topBar.isHidden = true
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topBar.isHidden = false
        bottomBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        resetState()
        dismiss(animated: true, completion: nil)
    }
    
    func saveMeme(){
        if let memedImage = self.memedImage{
            let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: sourceImage.image, memedImage:memedImage)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme)
            print("meme saved")
            dismiss(animated: true, completion: nil)
        }
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sourceImage.contentMode = .scaleAspectFit
            sourceImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}

