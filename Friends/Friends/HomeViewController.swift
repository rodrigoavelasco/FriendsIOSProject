//
//  HomeViewController.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

protocol UpdateHeight {
    func updateHeight(indexPath: IndexPath, height: CGFloat)
    
    func updateStringHeight(indexPath: IndexPath, height: CGFloat)
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, UpdateHeight{
    func updateStringHeight(indexPath: IndexPath, height: CGFloat) {
        cellStringHeights[indexPath]! = height
    }
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        
        if (!posts.isEmpty) {
            if posts.count % 10 == 0 {
                if indexPaths.first!.row >= posts.count {
                    print("****** loading next batch) ******* \(posts.count)")
                    loadNextBatch()
                }
            }
        }
    }
    
//    func tableView(_tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("****** loading next batch) ******* \(indexPath.row)")
//        if (!posts.isEmpty) {
//            if indexPath.row >= posts.count {
//                loadNextBatch()
//            }
//        }
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                // do here...
                loaded = true
            }
        }
        cellHeights[indexPath] = cell.frame.size.height

    }
    
    func loadNextBatch() {
        
        print("****** loading next batch) ******* \(compoundPostsCount)")
//        reload = false
        
//        print(self.compoundPosts)
        var itemExists: Bool = true
        let currentCount = self.posts.count + 10
        var count: Int = 0
        if (self.compoundPosts.count >= 1) {
            while self.compoundPosts[count].count == 0 && count < self.compoundPosts.count{
                count += 1
                
            }
            if count == self.compoundPosts.count {
                return
            }
            if self.compoundPosts[count].count > 10 {
                while self.posts.count < currentCount {
                    self.posts.append(self.compoundPosts[count].popLast()!)
                }
                self.tableView.reloadData()
                return
            } else {
                while self.posts.count < currentCount {
                    if count == self.compoundPosts.count {
                        return
                    } else if self.compoundPosts[count].count == 0 {
                        count += 1
                    } else {
                        self.posts.append(self.compoundPosts[count].popLast()!)
                    }
                }
                self.tableView.reloadData()
                return
            }
//            while self.posts.count < currentCount && itemExists {
//                 for i in 0 ..< self.compoundPosts.count {
//                    if i == self.compoundPosts.count && self.compoundPosts[i].count == 0 {
//                        itemExists = false
//                        break
//                    } else {
//                        while self.compoundPosts[i].count != 0 &&
//                            self.posts.count < currentCount {
//                            let pop = self.compoundPosts[i].popLast()
//                            if pop != nil {
//                                self.posts.append(pop!)
//                            } else {
//                                break
//                            }
//                        }
//                        compoundPostsCount += 1
//                    }
//                }
//            }
        }
        
//        print(self.posts)
//        print(self.compoundPosts)
        print(self.posts.count)
//        self.tableView.reloadData()
//        loaded = true
    }

    
    func updateHeight(indexPath: IndexPath, height: CGFloat) {
        cellHeights[indexPath]! = height
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + posts.count
//            return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let userDocumentRef = db.collection("users").document(uid!)
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUser", for: indexPath as IndexPath) as! HomeUserTableViewCell
            userDocumentRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let map = document.data()!
                    cell.homeNameLabel!.text = map["name"] as? String
                    cell.homeUserNameLabel!.text = map["username"] as? String
                    if map["image"] != nil {
                        cell.homeUserImageView!.load(url: URL(string: map["image"] as! String)!)
                    } else {
                        cell.homeUserImageView!.image = UIImage(named: "blank-profile-picture")
                    }
                } else {
                    print("Document does not exist")
                }
            }
//            let defaultImage = UIImage(named: "blank-profile-picture")
//            cell.homeUserImageView!.image = defaultImage
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeed", for: indexPath as IndexPath)
            return cell
        } else {
//            if indexPath.row == self.posts.count {
//                let queue = DispatchQueue(label: "aoeu", qos: .userInitiated)
//                queue.async {
//                    self.loadNextBatch()
//                    sleep(3)
//                    DispatchQueue.main.async{self.tableView.reloadData()
////                        print("******** \(self.posts.count)")
//                    }
//                }
//
//
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath as IndexPath) as! PostTableViewCell
            
            if globalDark {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected-dark")
            } else {
                cell.likeButton!.imageView!.image = UIImage(named: "heart-unselected")
            }
            
            let postNumber = indexPath.row - 2
            cell.addPost(postID: posts[postNumber])
            cell.rowID = indexPath.row
            cell.homeVC = self
            cell.indexPath = indexPath
            cell.updateHeight = self
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row <= 1 {
            return UITableView.automaticDimension
        }
//        if cellHeights[indexPath] == nil {
//            cellHeights[indexPath] = 0
//        }
//
//        if cellStringHeights[indexPath] == nil {
//            cellStringHeights[indexPath] = 0
//        }
        
//        return cellHeights[indexPath]! + cellStringHeights[indexPath]! + 80
        return UITableView.automaticDimension
//        if indexPath.row == 0 {
//            return 80
//        } else if indexPath.row == 1 {
//            return 50
//        } else {
//            return 135
//        }
    }
    var cellHeights = [IndexPath: CGFloat]()
    var cellStringHeights = [IndexPath: CGFloat]()

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var uid: String!
    var user: User!
    
    var friends: [String] = []
    var posts: [String] = []
    var compoundPosts: [[String]] = []
    var dates: [Date] = []
    
    var compoundPostsCount: Int = 0
    
    var loaded: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        uid = Auth.auth().currentUser!.uid
        user = User(uid: Auth.auth().currentUser!.uid)
        SettingsViewController().loadUserSettings()
        
        let userDocumentRef = db.collection("users").document(uid!)
        
        userDocumentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let map = document.data()!
                if map["friends"] != nil {
                    self.friends = map["friends"] as! [String]
                }
                self.friends.append(self.uid!)
//                if map["posts"] != nil {
//                    self.posts = map["posts"] as! [String]
//
                let postsRef = self.db.collection("posts")
                postsRef.whereField("uid", in: self.friends).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print ("Error getting documents: \(err)")
                    } else {
                        for document in (querySnapshot?.documents)! {
                            let data = document.data()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM d, yyyy"
                            let dateString = data["date"] as? String
                            let date = dateFormatter.date(from: dateString!)!
                            if (!self.dates.contains(date)) {
                                self.dates.append(date)
                            }
                        }
                        self.dates = self.dates.sorted(by: { $0.compare($1) == .orderedDescending })
//                        print(self.dates)
                        self.compoundPosts = Array(repeating: [], count: self.dates.count)
                        for document in (querySnapshot?.documents)! {
                            let data = document.data()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM d, yyyy"
                            let dateString = data["date"] as? String
                            let date = dateFormatter.date(from: dateString!)!
                            let index = self.dates.lastIndex(of: date)!
                            self.compoundPosts[index].append(document.documentID)
                        }
                        print(self.compoundPosts)
                        for i in 0..<self.compoundPosts.count {
                            self.compoundPosts[i] =     self.compoundPosts[i].shuffled()
                        }
                        print(self.compoundPosts)
                        var itemExists: Bool = true
                        while self.posts.count < 10 && itemExists {
                            if (self.compoundPostsCount < self.compoundPosts.count && !self.compoundPosts[self.compoundPostsCount].isEmpty) {
                                for i in 0 ..< self.compoundPosts.count {

                                    if i == self.compoundPosts.count && self.compoundPosts[i].count == 0 {
                                        itemExists = false
                                    } else {
                                        while self.compoundPosts[i].count != 0 && self.posts.count < 10 {

                                            let pop = self.compoundPosts[i].popLast()
                                            if pop != nil {
                                                self.posts.append(pop!)
                                            } else {
                                                break
                                            }
                                        }
                                        self.compoundPostsCount += 1
                                    }
                                }
                            }
                            else {
                                break
                            }
                        }
                        print(self.posts)
                        print(self.compoundPosts)
                        self.tableView.reloadData()
                    }
                }
//                for friend in self.friends {
//                    postsRef.whereField("posts", isEqualTo: friend).getDocuments() { (querySnapshot, err) in
//                        if let err = err {
//                            print ("Error getting documents: \(err)")
//                        } else {
//                            for document in querySnapshot!.documents {
//                                print("\(document.documentID) => \(document.data())")
//
//                            }
//                        }
//                    }
//                }
                                
            }
        }
        
    }
    
    
    @IBAction func myProfilePressed(_ sender: Any) {
        
    }
    
    @IBAction func newPostPressed(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        print(segue.identifier!)
        if segue.identifier != nil && segue.identifier! == "My Profile Segue" {
            print("My Profile Segue")
            if let tvc = segue.destination as? ProfilePageViewController {
                tvc.uid = uid!
//                print(uid!)
//                print(tvc.uid!)
                let trans = CATransition()
                trans.type = CATransitionType.moveIn
                trans.subtype = CATransitionSubtype.fromLeft
                trans.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                trans.duration = 0.35
                self.navigationController?.view.layer.add(trans, forKey: nil)
                
            }
        }
        if segue.identifier! == "Show Comments" {
            let commentsVC = segue.destination as! CommentsTableViewController
            commentsVC.postID = postIDSender
        }
    }
    var postIDSender: String!
}
