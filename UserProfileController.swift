//
//  userProfileController.swift
//  PlayerGround X
//
//  Created by Chandan Brown on 8/11/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import UIKit
import Firebase
import SwiftBomb

class UserProfileController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let cellId = "cellId"
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    let titles = [" PlayerGround"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://ign.com")
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                print(data)
                
                if error == nil {
                    
                    let urlContent = NSString(data: data!, encoding: NSASCIIStringEncoding) as NSString!
                    
                    print(urlContent)
                }
            })
            task.resume()
        }

        
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        let titleLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width - 52, view.frame.height))
        titleLabel.text = "  Profile"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(28)
        navigationItem.titleView = titleLabel
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.rgb(170, green: 170, blue: 170)
        
        setupCollectionView()
        setupMenuBar()
    }
    
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.rgb(170, green: 170, blue: 170)
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.pagingEnabled = false
    }
    
    func handleSearch() {
        scrollToMenuIndex(1)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(forItem: menuIndex, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    
    
    lazy var menuBar: UserMenuBar = {
        let mb = UserMenuBar()
        mb.profileController = self
        return mb
    }()
    
    private func setupMenuBar() {
        
        
        let grayView = UIView()
        grayView.backgroundColor = UIColor.rgb(170, green: 170, blue: 170)
        view.addSubview(grayView)
        view.addConstraintsWithFormat("H:|[v0]|", views: grayView)
        view.addConstraintsWithFormat("V:[v0]", views: grayView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0]", views: menuBar)
        
        menuBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 1
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.memory.x / view.frame.width
        
        let indexPath = NSIndexPath(forItem: Int(index), inSection: 0)
        menuBar.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier: String
        if indexPath.item == 1 {
            identifier = cellId
        } else {
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, view.frame.height - 50)
    }
    
    
}
