//
//  DashboardTitleController.swift
//  PlayerGround X
//
//  Created by Chandan Brown on 8/12/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

import UIKit

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = TabBarController()
        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
        item1.tabBarItem = icon1
        let controllers = [item1]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
