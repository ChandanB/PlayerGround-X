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
    
    weak var signInButton: GIDSignInButton!
    
    lazy var googleRegisterButton: GIDSignInButton! = {
    GIDSignInButtonColorScheme.Dark
    GIDSignInButtonStyle.Wide
    let button = GIDSignInButton()
    button.backgroundColor = UIColor(r: 90, g: 151, b: 213)
    button.translatesAutoresizingMaskIntoConstraints = false
    
            return button
    }()
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        if let error = error {
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            // ...
        }
        // ...
    }
    
    
    
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        let googleRegisterButton: GIDSignInButton! = {
            GIDSignInButtonColorScheme.Dark
            GIDSignInButtonStyle.Wide
            let button = GIDSignInButton()
            button.backgroundColor = UIColor(r: 90, g: 151, b: 213)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
            
        }()

        
        view.backgroundColor = UIColor(r: 176, g: 176, b: 176)
        
        view.addSubview(profileImageView)
        view.addSubview(googleRegisterButton)

        setupGoogleRegisterButton()
        setupProfileImage()
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


