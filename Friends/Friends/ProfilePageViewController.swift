//
//  ProfilePageViewController.swift
//  Friends
//
//  Created by Andrew Kim on 7/2/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal)
        navigationBar.setHidesBackButton(false, animated: false)
        self.navigationItem.setHidesBackButton(false, animated: false)
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
