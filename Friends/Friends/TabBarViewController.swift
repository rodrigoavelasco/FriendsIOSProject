//
//  TabBarViewController.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.tabBarController?.tabBar.items![1].image = UIImage(named: "Home.png")
//        self.tabBarController?.tabBar.items![2].image = UIImage(named: "settings2.png")
    }
    
    
    func darkMode(){
        overrideUserInterfaceStyle = .dark
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
