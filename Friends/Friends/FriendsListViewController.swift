//
//  FriendsListViewController.swift
//  Friends
//
//  Created by Jianjian Xie on 7/2/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let olddata = ["name", "username"]
    var list:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return olddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableCell", for: indexPath as IndexPath)
            as! UserTableViewCell
        let row = indexPath.row
        if list.count != 0 {
            let data = list[row]
            cell.name.text = data[0]
            cell.username.text = data[1]
//            cell.imageView?.image = data[2]
        }
        return cell
    }
    
    func fetchFriends() {
        
    }
}
