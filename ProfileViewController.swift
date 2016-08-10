//
//  ProfileViewController.swift
//  PlayerGround Messaging
//
//  Created by Chandan Brown on 7/29/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import UIKit
import Firebase
import SwiftBomb



class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    

   
        let cellId = "cellId"
        let trendingCellId = "trendingCellId"
        let subscriptionCellId = "subscriptionCellId"
        
        let titles = [" Home", "Trending", "Subscriptions", "Account"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            let configuration = SwiftBombConfig(apiKey: "8e2731b28614f3c3a1530f6780a7f18e259aff59", urlRequestCachePolicy: .UseProtocolCachePolicy)
            SwiftBomb.configure(configuration)
            
            navigationController?.navigationBar.tintColor = UIColor.blackColor()
            let titleLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width - 32, view.frame.height))
            titleLabel.text = "  Home"
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.font = UIFont.systemFontOfSize(20)
            navigationItem.titleView = titleLabel
            
            let statusBarBackgroundView = UIView()
            statusBarBackgroundView.backgroundColor = UIColor.rgb(178, green: 178, blue: 178)
            
            setupCollectionView()
            setupMenuBar()
            setupNavBarButtons()
        }
    
    
        func setupCollectionView() {
            if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.scrollDirection = .Horizontal
                flowLayout.minimumLineSpacing = 0
            }
            
            collectionView?.backgroundColor = UIColor.rgb(90, green: 151, blue: 213)
            collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
            collectionView?.registerClass(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
            collectionView?.registerClass(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
            
            collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
            
            collectionView?.pagingEnabled = true
        }
        
        func setupNavBarButtons() {
            let searchImage = UIImage(named: "search_icon")?.imageWithRenderingMode(.AlwaysOriginal)
            let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .Plain, target: self, action: #selector(handleSearch))
            
            let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(handleMore))
            
            navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        }
        
        lazy var settingsLauncher: SettingsLauncher = {
            let launcher = SettingsLauncher()
            launcher.profileController = self
            return launcher
        }()
    
        func handleMore() {
            //show menu
            settingsLauncher.showSettings()
        }
        
        func showControllerForSetting(setting: Setting) {
            let dummySettingsViewController = UIViewController()
            dummySettingsViewController.view.backgroundColor = UIColor.whiteColor()
            dummySettingsViewController.navigationItem.title = setting.name.rawValue
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.rgb(90, green: 151, blue: 213)]
            navigationController?.pushViewController(dummySettingsViewController, animated: true)
        }
        
        func handleSearch() {
            scrollToMenuIndex(2)
        }
        
        func scrollToMenuIndex(menuIndex: Int) {
            let indexPath = NSIndexPath(forItem: menuIndex, inSection: 0)
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
            
            setTitleForIndex(menuIndex)
        }
        
        private func setTitleForIndex(index: Int) {
            if let titleLabel = navigationItem.titleView as? UILabel {
                titleLabel.text = "  \(titles[index])"
            }
            
        }
        
        lazy var menuBar: MenuBar = {
            let mb = MenuBar()
            mb.profileController = self
            return mb
        }()
        
        private func setupMenuBar() {
            navigationController?.hidesBarsOnSwipe = true
            
            let blueView = UIView()
            blueView.backgroundColor = UIColor.rgb(90, green: 151, blue: 213)
            view.addSubview(blueView)
            view.addConstraintsWithFormat("H:|[v0]|", views: blueView)
            view.addConstraintsWithFormat("V:[v0(50)]", views: blueView)
            
            view.addSubview(menuBar)
            view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
            view.addConstraintsWithFormat("V:[v0(50)]", views: menuBar)
            
            menuBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        }
        
        override func scrollViewDidScroll(scrollView: UIScrollView) {
            menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
        }
        
        override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            let index = targetContentOffset.memory.x / view.frame.width
            
            let indexPath = NSIndexPath(forItem: Int(index), inSection: 0)
            menuBar.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            
            setTitleForIndex(Int(index))
        }
        
        override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
        }
        
        override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let identifier: String
            if indexPath.item == 1 {
                identifier = trendingCellId
            } else if indexPath.item == 2 {
                identifier = subscriptionCellId
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
