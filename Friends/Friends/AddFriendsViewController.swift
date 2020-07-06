//
//  AddFriendsViewController.swift
//  Friends
//
//  Created by 谢戬戬 on 7/5/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let data = ["name", "username"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search New Friends"
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath as IndexPath)
            as! UserTableViewCell
        cell.name.text = data[0]
        cell.username.text = data[1]
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

}
