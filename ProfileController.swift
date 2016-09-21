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
            GIDSignInButtonColorScheme.dark
            GIDSignInButtonStyle.wide
            let button = GIDSignInButton()
            button.backgroundColor = UIColor(r: 90, g: 151, b: 213)
            button.translatesAutoresizingMaskIntoConstraints = false
    
            return button
    }()
    
    
   lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "PlayerGround")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    imageView.isUserInteractionEnabled = true
    
    return imageView
   }()
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout of Services", style: .plain, target: self, action: #selector(handleLogout))
        
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
        
        present(messagesController, animated: true, completion: nil)
    }

    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: googleRegisterButton.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    func setupGoogleRegisterButton() {
                googleRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                googleRegisterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                googleRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
                googleRegisterButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}


