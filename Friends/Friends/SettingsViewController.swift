//
//  SettingsViewController.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    let darkModeSwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
    var darkMode = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 1
        } else if section == 5 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchSettings", for: indexPath as IndexPath)
                if indexPath.row == 0 {
                    cell.textLabel!.text = "Location Services"
                } else if indexPath.row == 2 {
                    cell.textLabel!.text = "Enable Screen Security"
                } else {
                    cell.textLabel!.text = "This shouldn't appear!"
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowSettings", for: indexPath as IndexPath)
                if indexPath.row == 1 {
                    cell.textLabel!.text = "Blocked Friends"
                } else {
                    cell.textLabel!.text = "This shouldn't appear"
                }
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel!.text = "This shouldn't appear!"
                return cell
            }
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowSettings", for: indexPath as IndexPath)
            if indexPath.row == 0 {
                cell.textLabel!.text = "Change Username"
                return cell
            } else if indexPath.row == 1 {
                cell.textLabel!.text = "Change Password"
            } else {
                cell.textLabel!.text = "This shouldn't appear!"
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowSettings", for: indexPath as IndexPath)
            if indexPath.row == 0 {
                cell.textLabel!.text = "Notification Sound"
            } else {
                cell.textLabel!.text = "This shouldn't appear!"
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchSettings", for: indexPath as IndexPath)
            if indexPath.row == 0 {
                cell.textLabel!.text = "Dark Mode"
                darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode(_:)), for: .valueChanged)
                cell.accessoryView = darkModeSwitch
            } else {
                cell.textLabel!.text = "This shouldn't appear!"
            }
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutSettings", for: indexPath as IndexPath)
            if indexPath.row == 0 {
                cell.textLabel!.textColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                cell.textLabel!.text = "Log Out"
            } else {
                cell.textLabel!.text = "This shouldn't appear!"
            }
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteAccount", for: indexPath as IndexPath)
            if indexPath.row == 0 {
                cell.textLabel!.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                cell.textLabel!.font = UIFont(descriptor: UIFontDescriptor(name: "System Bold", size: 17), size: 17)
                cell.textLabel!.text = "DELETE ACCOUNT"
                return cell
            } else {
                cell.textLabel!.text = "This shouldn't appear!"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataSettings", for: indexPath as IndexPath)
            cell.textLabel!.text = "This shouldn't appear"
            return cell
        }
//        return UITableViewCell()
    }
    
    @IBAction func toggleDarkMode(_ sender: UISwitch){
        if sender.isOn {
            darkMode = true
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        (self.parent?.parent as! TabBarViewController).delegate = self

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 // number of required sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Privacy Settings"
        } else if section == 1 {
            return "Account Settings"
        } else if section == 2 {
            return "Notification Settings"
        } else if section == 3 {
            return "Appearance Settings"
        } else if section == 4 {
            return "Log Out"
        } else if section == 5 {
            return "Delete Account"
        } else {
            return "This shouldn't appear!"
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if darkMode{
            (tabBarController as! TabBarViewController).darkMode()
        }
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
