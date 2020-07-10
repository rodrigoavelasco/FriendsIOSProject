//
//  ProfilePageViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/2/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import AVFoundation
import Foundation

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, UpdateHeight {
    func updateStringHeight(indexPath: IndexPath, height: CGFloat) {
        cellStringHeights[indexPath]! = height
    }
    
    func updateHeight(indexPath: IndexPath, height: CGFloat) {
        cellHeights[indexPath]! = height
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
    }
    
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if (!posts.isEmpty) {
            if indexPaths.first!.row >= posts.count {
                loadNextBatch()
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 4
        if !posts.isEmpty {
            result += posts.count
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "User Info", for: indexPath as IndexPath) as! UserProfileTableViewCell
            cell.uid = uid!
            cell.currentVC = self
            let userDocumentRef = db.collection("users").document(uid!)
            
            userDocumentRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let map = document.data()!
                    cell.name!.text = map["name"] as? String
                    cell.userName!.text = map["username"] as? String
                    cell.email!.text = map["email"] as? String
                    if map["birthday"] != nil {
                        cell.birthday!.text = map["birthday"] as? String
                    } else {
                        cell.birthday!.text = "Tap to set"
                    }
                    if map["phone"] != nil {
                        cell.phone!.text = map["phone"] as? String
                    } else {
                        cell.phone!.text = "Tap to set"
                    }
                    if map["location"] != nil {
                        cell.location!.text = map["location"] as? String
                    } else {
                        cell.location!.text = "Tap to set"
                    }
                    if map["image"] != nil {
                        cell.userImage!.load(url: URL(string: (map["image"] as? String)!)!)
                    } else {
                        if self.me {
                            cell.imageSetView!.isHidden = false
                            cell.imageTapToSet!.isHidden = false
                        }
                        cell.userImage!.image = UIImage(named: "blank-profile-picture")
                    }
                } else {
                    print("Document does not exist")
                }
            }

            cell.layoutIfNeeded()
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsLabel", for: indexPath as IndexPath)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsList", for: indexPath as IndexPath) as! UserProfileFriendsListTableViewCell
            cell.uid = uid!
            cell.layoutIfNeeded()
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PastPostsLabel", for: indexPath as IndexPath)
            return cell
        } else if indexPath.row >= 4 {
//            if indexPath.row == 4 + posts.count - 1 && reload {
//                loadNextBatch()
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath as IndexPath) as! PostTableViewCell
            if globalDark {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected-dark")
            } else {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected")
            }
            cell.uid = uid!
            cell.userName!.text = userName!
            if(imageString != nil) {
                cell.userImage.load(url: URL(string:imageString!)!)
            }
            cell.currentVC = self
            let postNumber = indexPath.row - 4
            cell.addPost(postID: posts[posts.count - 1 - postNumber])
            
            cell.rowID = indexPath.row
            cell.layoutIfNeeded()
            cell.indexPath = indexPath
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 3 {
            return UITableView.automaticDimension
        }
//        if indexPath.row == 0 {
//            return 210
//        } else if indexPath.row == 1 {
//            return 40
//        } else if indexPath.row == 2 {
//            return 132
//        } else if indexPath.row == 3 {
//            return 40
//        } else if indexPath.row >= 4 {
//            let tempIndexPath = IndexPath(row: indexPath.row, section: 0)
//            let cell = self.tableView.cellForRow(at: tempIndexPath) as? PostTableViewCell
//            var result: CGFloat = 25
//            result += (cell?.userImage!.frame.size.height) ?? 0
//            result += (cell?.postText!.frame.size.height) ?? 0
//            if result == 25 {
//                return 150
//            }
//            return result
//        }
//        else {
//            return 200
//        }
        
        if cellHeights[indexPath] == nil {
            cellHeights[indexPath] = 0
        }
        if cellStringHeights[indexPath] == nil{
            cellHeights[indexPath] = 0
        }
        
        return UITableView.automaticDimension

        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
//            if indexPath == lastVisibleIndexPath && reload! {
//                loadNextBatch()
//            }
//        }
//    }
    
    
    private func calculateIndexPathsToRelad(from newPosts: [String]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
    }
    
    func loadNextBatch() {
        print("loading next batch)")
//        reload = false
        let userDocumentRef = db.collection("users").document(uid!)
        
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                if map["posts"] != nil {
                    
                    let allPosts = map["posts"] as! [String]
                    if allPosts.count <= 5 {
                        self.posts = allPosts
//                        self.reload = false
                    } else {
                        let amount = self.posts.count + 5
                        if allPosts.count > amount {
                            let slice: ArraySlice<String> = allPosts[allPosts.count - amount ... allPosts.count - 1]
                            self.posts = Array<String>() + slice
//                            self.reload = true
                        } else {
                            self.posts = Array<String>() + allPosts
//                            self.reload = false
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    print("empty posts")
                }
               
            } else {
                print("Document does not exist")
            }
        }

    }
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        print("block button pressed")
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["blocked": FieldValue.arrayUnion([uid!])])
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["friends": FieldValue.arrayRemove([uid!])])
        self.navigationItem.setRightBarButtonItems(nil, animated: false)
        
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        print("delete button pressed")
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["friends": FieldValue.arrayRemove([uid!])])
        self.navigationItem.setRightBarButtonItems([self.addButton, self.blockButton], animated: false)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        print("add button pressed")
        db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["friends": FieldValue.arrayUnion([uid!])])
        self.navigationItem.setRightBarButtonItems([self.deleteButton, self.blockButton], animated: false)
    }
    
    @IBOutlet var tableView: UITableView!
    var uid: String!
    var delegate:UIViewController!
    var container:[String]!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var posts: [String] = []
    var myFriends: [String] = []
    var myBlocked: [String] = []
    var friends: [String] = []
//    var reload: Bool!
    var imageString: String!
    var userName: String!
    
    var me: Bool = true
    
    var cellHeights = [IndexPath: CGFloat]()
    var cellStringHeights = [IndexPath: CGFloat]()
    
    @IBOutlet var blockButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var blankButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (uid!)
//        reload = false
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        if Auth.auth().currentUser!.uid != uid! {
            me = false
            let userDocumentRef = db.collection("users").document(uid!)
            userDocumentRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
                    let map = document.data()!
                    let username = map["name"] as! String
                    self.navigationItem.title! = username
                    if map["posts"] != nil {
                        self.posts = (map["posts"] as? [String])!
                    }
//                    print("my friends: \(self.myFriends)")
                    let myDocumentRef = self.db.collection("users").document(Auth.auth().currentUser!.uid)
                    myDocumentRef.getDocument{ (document, error) in
                        if let document = document, document.exists {
                            let map = document.data()!
//                            print("myUID: \(Auth.auth().currentUser!.uid)")
//                            print("friends: \(map["friends"] as! [String])")
                            if map["friends"] != nil {
                                self.myFriends = (map["friends"] as? [String])!
                            }
                            if map["blocked"] != nil {
                                self.myBlocked = (map["blocked"] as? [String])!
                            }
//                            print(self.myFriends)
                            if self.myFriends.contains(self.uid!) {
                                print("friend exeists")
                                self.navigationItem.setRightBarButtonItems([self.deleteButton, self.blockButton], animated: true)
                            } else{
                                print("friend not exeists")
                                self.navigationItem.setRightBarButtonItems([self.addButton, self.blockButton], animated: true)
                            }
                            if self.myBlocked.contains(self.uid!) {
//                                self.navigationItem.title! = "My Profile Page"
                                self.navigationItem.setRightBarButtonItems(nil, animated: false)

                            }
                        }
                    }
                    
                } else {
                    print("Document does not exist")
                }
            }
            
        } else {
            self.navigationItem.title! = "My Profile Page"
            self.navigationItem.setRightBarButtonItems(nil, animated: false)
        }
        
        let userDocumentRef = db.collection("users").document(uid!)
        
        userDocumentRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let map = document.data()!
                if map["posts"] != nil {
                    
                    let allPosts = map["posts"] as! [String]
                    if allPosts.count <= 5 {
                        self.posts = allPosts
                    } else {
                        let slice: ArraySlice<String> = allPosts[allPosts.count - 6 ... allPosts.count - 1]
                        self.posts = Array<String>() + slice
//                        self.reload = true
                    }
                    self.tableView.reloadData()
                } else {
                    print("empty posts")
                }
                if map["image"] != nil {
                    self.imageString = map["image"] as? String
                }
                self.userName = map["name"] as? String
               
            } else {
                print("Document does not exist")
            }
        }
        
        
//        self.tableView.estimatedRowHeight = UITableView.automaticDimension
//        self.tableView.rowHeight = UITableView.automaticDimension
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "Show Comments" {
            let commentsVC = segue.destination as! CommentsTableViewController
            commentsVC.postID = postIDSender!
            commentsVC.profileVC = self
        }
    }
    var postIDSender: String!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension ProfilePageViewController {
    func isLoadingcell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= posts.count + 4
    }
}
