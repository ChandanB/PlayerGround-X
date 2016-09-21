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
       

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        
    FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //            user.name = dictionary["name"]
            }
            
            }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = users.filter { users in
            return users.name!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredUsers.count
            }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user: User
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[(indexPath as NSIndexPath).row]
        func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
                dismiss(animated: true) {
                    print("Dismiss completed")
                    let user = self.users[(indexPath as NSIndexPath).row]
                    self.messagesController?.showChatControllerForUser(user)
                }
            }

        } else {
            user = users[(indexPath as NSIndexPath).row]
        }
        cell.textLabel?.text = user.name
        
        if user.userProfileLink == "" {
            cell.detailTextLabel?.text = user.email
        } else {
            cell.detailTextLabel?.text = user.userProfileLink
        }
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("Dismiss completed")
            let user = self.users[(indexPath as NSIndexPath).row]
            self.messagesController?.showChatControllerForUser(user)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var user: User
                if searchController.isActive && searchController.searchBar.text != "" {
                    user = filteredUsers[(indexPath as NSIndexPath).row]
                } else {
                    user = self.users[(indexPath as NSIndexPath).row]
                }
                if searchController.isActive && searchController.searchBar.text != "" {
                    user = filteredUsers[(indexPath as NSIndexPath).row]
                }
                let controller = (segue.destination as! UINavigationController).topViewController as! ChatLogController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}


extension NewMessageController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}








