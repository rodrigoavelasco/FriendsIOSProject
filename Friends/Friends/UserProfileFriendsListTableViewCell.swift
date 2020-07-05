//
//  UserProfileFriendsListTableViewCell.swift
//  Friends
//
//  Created by Andrew Kim on 7/4/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class UserProfileFriendsListTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsList.dequeueReusableCell(withIdentifier: "Friend", for: indexPath as IndexPath)
        return cell
    }
    

    @IBOutlet weak var friendsList: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendsList.delegate = self
        friendsList.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
