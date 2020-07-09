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
import Firebase
import FirebaseFirestoreSwift

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    var results: [[String]] = []
    var index:Int = 0
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItemInitialized()
        self.tableViewInitialized()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.frame.width / 4, y: (view.frame.height-200)/2, width: view.frame.width/2, height: 200)
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath as IndexPath)
            as! UserTableViewCell
        let row = indexPath.row
        print("reload")
        if results.count != 0 {
            let arr:[String] = results[row]
            cell.username.text = arr[0]
            cell.name.text = arr[1]
            let url = arr[2]
            if let url = URL(string: url) {
                DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        if cell.downloaded {
                            cell.imageView?.image = image
                            self.tableView.reloadData()
                            cell.downloaded = false
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        print("ole ole ole ole")
        performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        results = []
        guard let text = searchController.searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        let ref = db.collection("users")
        ref.whereField("name", isEqualTo: query).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let name = data["name"] as? String
                    let username = data["username"] as? String
                    let image = data["image"] as? String
                    let uid = document.documentID
                    var arr:[String] = []
                    arr.append(username!)
                    arr.append(name!)
                    arr.append(image ?? "")
                    arr.append(uid)
                    self.results.append(arr)
                    print("count: \(self.results.count)")
                }
                self.updateUI()
            }
        }
        ref.whereField("username", isEqualTo: query).getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let name = data["name"] as? String
                    let username = data["username"] as? String
                    let image = data["image"] as? String
                    let uid = document.documentID
                    var arr:[String] = []
                    arr.append(username!)
                    arr.append(name!)
                    arr.append(image ?? "")
                    arr.append(uid)
                    print(arr)
                    self.results.append(arr)
                }
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        self.tableView.isHidden = results.isEmpty
        self.noResultsLabel.isHidden = !results.isEmpty
        if !results.isEmpty {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("perform segue")
        if segue.identifier == "ProfileSegue", let destination = segue.destination as? ProfilePageViewController
//            let index = tableView.indexPathForSelectedRow?.row
        {
            destination.uid = results[index][3]
            print(destination.uid)
        }
    }
}
