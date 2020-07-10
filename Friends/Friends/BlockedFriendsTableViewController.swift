//
//  BlockedFriendsTableViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/9/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class BlockedFriendsTableViewController: UITableViewController {

    var blockedFriends: [String] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "BlockedFriendsTableCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("users").document(uid)
        docRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                let map = document.data()!
                if map["blocked"] != nil {
                    self.blockedFriends = map["blocked"] as! [String]
                    self.tableView.reloadData()
                }
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(blockedFriends.count)
        return blockedFriends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedFriendsTableCell", for: indexPath) as! UserTableViewCell
        let docRef = db.collection("users").document(blockedFriends[indexPath.row])
        docRef.getDocument() { (document, error) in
            if let document = document, document.exists {
                let map = document.data()!
                cell.avatar.load(url: URL(string: map["image"] as! String)!)
                cell.name!.text = map["name"] as! String
                cell.username!.text = map["username"] as! String
            }
        }

        // Configure the cell...
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
