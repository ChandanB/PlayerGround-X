//
//  ViewController.swift
//  PlayerGround 5.0
//
//  Created by Chandan Brown on 7/22/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//


import UIKit
import Firebase




class NewMessageController: UITableViewController {
    
   
    let searchController = UISearchController(searchResultsController: nil)
    
    let cellId = "cellId"
    var users = [User]()
    var filteredUsers = [User]()
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Name"]
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor.rgb(90, green: 151, blue: 213)
       

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        
    FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(id: nil, name: nil, email: nil, profileImageUrl: nil)
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
            }, withCancelBlock: nil)
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { users in
            return users.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchController.active && searchController.searchBar.text != "" {
                return filteredUsers.count
            }
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        let user: User
        if searchController.active && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        return cell
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let user: User
                if searchController.active && searchController.searchBar.text != "" {
                    user = filteredUsers[indexPath.row]
                } else {
                    user = self.users[indexPath.row]
                }
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ChatLogController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}


extension NewMessageController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}








