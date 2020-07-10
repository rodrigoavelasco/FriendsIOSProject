//
//  CommentsTableViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class CommentsTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.delegate = self
        tableView.dataSource = self
        let docsRef = db.collection("posts").document(postID)
        docsRef.getDocument { (document, error) in
            if (error != nil) {
                print(error)
                return
            }
            let map = document!.data()!
            if map["comments"] != nil {
                self.comments = map["comments"] as! [String]
            }
            if map["uid"] as! String != Auth.auth().currentUser!.uid {
                let userRef = self.db.collection("users").document(map["uid"] as! String)
                userRef.getDocument() { (document, error) in
                    if let document = document, document.exists {
                        let userMap = document.data()!
                        let name = userMap["name"] as! String
                        self.navigationItem.title = name

                    }
                }
            }
            self.tableView.reloadData()
        }
        if globalDark {
            tableView.backgroundColor = UIColor.black
        } else {
            tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func addComments() {
        let docsRef = db.collection("posts").document(postID)
        docsRef.getDocument { (document, error) in
            if (error != nil) {
                print(error)
                return
            }
            let map = document!.data()!
            if map["comments"] != nil {
                self.comments = map["comments"] as! [String]
                self.tableView.reloadData()
            }
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return 3 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath as IndexPath) as! PostTableViewCell
            if globalDark {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected-dark")
            } else {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected")
            }
            
            let postNumber = postID!
            cell.addPost(postID: postNumber)
            cell.rowID = indexPath.row
//            cell.homeVC = self
            cell.commentsVC = self
            cell.indexPath = indexPath
            cell.layoutIfNeeded()

            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath as IndexPath)
            return cell
        } else if indexPath.row >= 2 && indexPath.row < tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath as IndexPath) as! CommentTableViewCell
            cell.commentID = comments[indexPath.row - 2]
            cell.addComment(commentID: comments[indexPath.row - 2])
            return cell
        }
        else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "New Comment", for: indexPath as IndexPath) as! NewCommentTableViewCell
            cell.postID = postID!
            cell.commentTVC = self
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 200
//        } else if indexPath.row == 1 {
//            return 50
//        } else if indexPath.row >= 2 && indexPath.row < tableView.numberOfRows(inSection: 0) - 2 {
//            return 200
//        } else if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
//            return 100
//        } else {
//            return 0
//        }
        return UITableView.automaticDimension
    }

    
    func textFieldShouldReturn(textField:UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
   }
       

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    // code to enable tapping on the background to remove software keyboard
    
    var postID: String!
    var comments: [String] = []
}
