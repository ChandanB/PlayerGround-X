//
//  User Profile Controller.swift
//  PlayerGround X
//
//  Created by Chandan Brown on 8/12/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
class ProfileController: UIViewController, GIDSignInUIDelegate {
    
    var messagesController = MessagesController()
    
    
    weak var signInButton: GIDSignInButton!
    
        lazy var googleRegisterButton: GIDSignInButton! = {
            GIDSignInButtonColorScheme.Dark
            GIDSignInButtonStyle.Wide
            let button = GIDSignInButton()
            button.backgroundColor = UIColor(r: 90, g: 151, b: 213)
            button.translatesAutoresizingMaskIntoConstraints = false
    
            return button
    }()
    
    
   lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "PlayerGround")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .ScaleAspectFill
    
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    imageView.userInteractionEnabled = true
    
    return imageView
   }()
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("canceled picker")
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout of Services", style: .Plain, target: self, action: #selector(handleLogout))
        
        view.backgroundColor = UIColor(r: 176, g: 176, b: 176)
        
        view.addSubview(profileImageView)
        view.addSubview(googleRegisterButton)

        setupGoogleRegisterButton()
        setupProfileImage()
    }
    
    func handleLogout() {
        
        do {
            
            try! FIRAuth.auth()!.signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
        
        presentViewController(messagesController, animated: true, completion: nil)
    }

    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(googleRegisterButton.topAnchor, constant: -12).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }

    func setupGoogleRegisterButton() {
                googleRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
                googleRegisterButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
                googleRegisterButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
                googleRegisterButton.heightAnchor.constraintEqualToConstant(150).active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}


