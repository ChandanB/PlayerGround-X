//
//  MenuBar.swift
//  youtube
//
//  Created by Brian Voong on 6/6/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.whiteColor()
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["home", "trending", "subscriptions", "account"]
    
    var profileController: ProfileViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.registerClass(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.whiteColor()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        //old school frame way of doing things
//        horizontalBarView.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        //new school way of laying out our views
        //in ios9
        //need x, y, width, height constraints
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.active = true
        
        horizontalBarView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        horizontalBarView.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/4).active = true
        horizontalBarView.heightAnchor.constraintEqualToConstant(4).active = true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        print(indexPath.item)
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
//        
//        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { 
//            self.layoutIfNeeded()
//            }, completion: nil)
        
        profileController?.scrollToMenuIndex(indexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.imageWithRenderingMode(.AlwaysTemplate)
        cell.tintColor = UIColor.rgb(91, green: 14, blue: 13)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width / 4, frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")?.imageWithRenderingMode(.AlwaysTemplate)
        iv.tintColor = UIColor.darkGrayColor()
        return iv
    }()
    
    override var highlighted: Bool {
        didSet {
            imageView.tintColor = highlighted ? UIColor.rgb(90, green: 151, blue: 213) : UIColor.blackColor()        }
    }
    
    override var selected: Bool {
        didSet {
            imageView.tintColor = selected ? UIColor.rgb(90, green: 151, blue: 213) : UIColor.darkGrayColor()        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintsWithFormat("H:[v0(28)]", views: imageView)
        addConstraintsWithFormat("V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
}







