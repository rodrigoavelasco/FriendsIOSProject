//
//  AddFriendsViewController.swift
//  Friends
//
//  Created by Jianjian Xie on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    let data = ["name", "username"]
    var results: [String] = []
    var hasFetched:Bool = false
    var usersCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItemInitialized()
        self.tableViewInitialized()
    }
    
    func tableViewInitialized() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    func navigationItemInitialized() {
        navigationItem.title = "Search New Friends"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath as IndexPath)
            as! UserTableViewCell
        if results.count != 0 {
            cell.name.text = data[0]
            cell.username.text = data[1]
        }
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        results = []
        guard let text = searchController.searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        
        updateUI()
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
    }
    
//    func getAllUsers(completion: @escaping (Result<[[String: [String]]], Error>) -> Void) {
//        db.child("users").observeSingleEvent(of:.value, with: { snapshot in
//                guard
//        })
//    }
    
    func updateUI() {
        self.tableView.isHidden = results.isEmpty
        if results.isEmpty {
           // no result message shown
        } else {
            self.tableView.reloadData()
        }
    }

}
