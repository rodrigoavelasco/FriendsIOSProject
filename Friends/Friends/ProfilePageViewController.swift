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

class ProfilePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if false {
            return 5
        } else {
            return 10
        }
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
                        cell.userImage!.image = UIImage(named: "blank-profile-picture")
                    } else {
                        cell.imageSetView!.isHidden = false
                        cell.imageTapToSet!.isHidden = false
                    }
                } else {
                    print("Document does not exist")
                }
            }


            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsLabel", for: indexPath as IndexPath)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsList", for: indexPath as IndexPath) as! UserProfileFriendsListTableViewCell
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PastPostsLabel", for: indexPath as IndexPath)
            return cell
        } else if indexPath.row >= 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath as IndexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 210
        } else if indexPath.row == 1 {
            return 40
        } else if indexPath.row == 2 {
            return 132
        } else if indexPath.row == 3 {
            return 40
        } else if indexPath.row >= 4 {
            return 200
        }
        else {
            return 200
        }
    }
    

    @IBOutlet var tableView: UITableView!
    var uid: String!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
