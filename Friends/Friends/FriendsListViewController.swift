//
//  FriendsListViewController.swift
//  Friends
//
//  Created by Jianjian Xie on 7/2/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

protocol FriendReloader {
    func reloadTable()
}

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendReloader {
    func reloadTable() {
        self.list = []
        fetchUIDs()
        self.tableView.reloadData()
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    let olddata = ["name", "username"]
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
//    let user = User(uid: Auth.auth().currentUser!.uid)
    var list:[[String]] = []
    var index:Int = 0
    var friendsUID:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInitialized()
        fetchUIDs()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidLoad()
//        tableView.reloadData()
//    }
    
    func tableViewInitialized() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.isHidden = true
        tableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath as IndexPath)
            as! UserTableViewCell
        let row = indexPath.row
        if list.count != 0 {
            let data = list[row]
            cell.name.text = data[0]
            cell.username.text = data[1]
            let url = data[2]
            if let url = URL(string: url) {
                DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else {
                        return
                    }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        if cell.downloaded {
                            cell.imageView?.image = image
                            self.tableView.reloadData()
                            cell.downloaded = false
                        }
                    }
                    DispatchQueue.main.async {
                        cell.downloaded = true
                    }
                }
            }
            if url == nil || url == "" {
                cell.imageView?.image = nil
                cell.downloaded = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            index = indexPath.row
            performSegue(withIdentifier: "ProfileSegue1", sender: nil)
    }
    
    func fetchUIDs() {
        let userDocumentRef = db.collection("users").document(uid)
        userDocumentRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let data = document.data()!
            if data["friends"] != nil {
                self.friendsUID = data["friends"] as! [String]
                print(self.friendsUID)
                self.fetchFriends()
//                self.updateUI()
            }
        }}
    }
    
    func fetchFriends() {
        if friendsUID.count != 0 {
            var tempList: [[String]] = []
            var count: Int = 0
            for id in friendsUID {
                let userDocumentRef = db.collection("users").document(id)
                    userDocumentRef.getDocument { (document, error) in
                     if let document = document, document.exists {
                         let data = document.data()!
                         print("!!!!!!!!!!!!!")
                         print(data)
                         let name = data["name"] as? String
                         let username = data["username"] as? String
                         let image = data["image"] as? String
                         let uid = document.documentID
                         var arr:[String] = []
                         arr.append(username!)
                         arr.append(name!)
                         arr.append(image ?? "")
                         arr.append(uid)
                         tempList.append(arr)
                            count += 1
                         print("count: \(self.list.count)")
                        if count == self.friendsUID.count {
                            print("&&&& count &&&&")
                            self.list = tempList
                             self.updateUI()
                         }
                     }}
                }
//            self.updateUI()
        }
    }
    
    func updateUI() {
        print("???????????????????")
        print(list.count)
        self.tableView.isHidden = list.isEmpty
        if !list.isEmpty {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("perform segue1")
            if segue.identifier == "ProfileSegue1", let destination = segue.destination as? ProfilePageViewController {
                destination.uid = list[index][3]
                destination.delegate = self
            } else if segue.identifier == "AddFriendSegue", let destination = segue.destination as? AddFriendsViewController {
                destination.delegate = self
            }
    }
}
