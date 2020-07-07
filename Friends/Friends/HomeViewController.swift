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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
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
                    cell.homeNameLabel!.text = map["name"] as! String
                    cell.homeUserNameLabel!.text = map["username"] as! String
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath as IndexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 50
        } else {
            return 135
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        uid = Auth.auth().currentUser!.uid
        user = User(uid: Auth.auth().currentUser!.uid)
        
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
        print(segue.identifier!)
        if segue.identifier! == "My Profile Segue" {
            print("My Profile Segue")
            if let tvc = segue.destination as? ProfilePageViewController {
                tvc.uid = uid!
//                print(uid!)
//                print(tvc.uid!)
                
            }
        }
    }
}
