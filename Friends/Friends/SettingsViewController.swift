//
//  SettingsViewController.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    let darkModeSwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
    let locationServicesSwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
    let enableScreenSecuritySwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
    let enableBiometricLoginSwitch = UISwitch(frame: CGRect(x: 1, y: 1, width: 20, height: 20))
    var darkMode = false
    var screenSecurity = false
    let userID:String = (Auth.auth().currentUser?.uid)!
    var tabBarDelegate: UITabBarControllerDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 1
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
            if indexPath.row == 1 || indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchSettings", for: indexPath as IndexPath)
                if indexPath.row == 1 {
                    cell.textLabel!.text = "Enable Screen Security"
                    enableScreenSecuritySwitch.addTarget(self, action: #selector(toggleScreenSecurity(_:)), for: .valueChanged)
                    cell.accessoryView = enableScreenSecuritySwitch
                } else if indexPath.row == 2{
                    cell.textLabel!.text = "Enable Automatic Biometric Log In"
                    enableBiometricLoginSwitch.addTarget(self, action: #selector(toggleAutomaticBiometricLogin(_:)), for: .valueChanged)
                    cell.accessoryView = enableBiometricLoginSwitch
                } else {
                    cell.textLabel!.text = "This shouldn't appear!"
                }
                return cell
            } else if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowSettings", for: indexPath as IndexPath)
                if indexPath.row == 0 {
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
    
    @IBAction func toggleScreenSecurity(_ sender: UISwitch){
        toggleSwitches(toggleStatus: sender.isOn, settingKey: "screensecurity")
    }
    
    @IBAction func toggleAutomaticBiometricLogin(_ sender: UISwitch){
        print("toggle Biometric login ON or OFF")
        toggleSwitches(toggleStatus: sender.isOn, settingKey: "biometriclogin")
    }
    
    @IBAction func toggleDarkMode(_ sender: UISwitch){
        toggleSwitches(toggleStatus: sender.isOn, settingKey: "darkmode")
    }
    
    func toggleSwitches(toggleStatus: Bool, settingKey: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // gives a pointer to the class app delegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        var fetchedResults: [NSManagedObject]? = nil
        let predicate = NSPredicate(format: "uid MATCHES '\(userID)'")
        request.predicate = predicate
        
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch{
            // error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        let settings = fetchedResults![0]
        
        if toggleStatus{
            
            settings.setValue(true, forKey: settingKey)
            
            // Commit changes
            do {
                try context.save()
            } catch {
                // error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            if settingKey == "darkmode"{
                darkMode = true
                overrideUserInterfaceStyle = .dark
            }
            
        } else if !toggleStatus{
            settings.setValue(false, forKey: settingKey)
            
            // Commit changes
            do {
                try context.save()
            } catch {
                // error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            if settingKey == "darkmode"{
                  darkMode = false
                  overrideUserInterfaceStyle = .light
            }
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        (self.parent?.parent as! TabBarViewController).delegate = self
        tabBarDelegate = (self.parent?.parent as! TabBarViewController).delegate
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadUserSettings()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let cell = indexPath.row
        switch section {
        case 0:
            if cell == 1{
                print("blocked friends section")
                self.performSegue(withIdentifier: "blockedFriendsSegue", sender: nil)
            }
        case 1:
            print("change password")
            self.performSegue(withIdentifier: "changePasswordSegueIdentifier", sender: nil)
            
        case 2:
            if cell == 0{
                print("notification sounds")
            }
        case 4:
            logOut()
        case 5:
            deleteAccount()
        default:
            print("shouldn't be here")
        }
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        performSegue(withIdentifier: "loginScreenSegueIdentifier", sender: nil)
    }
    
    func deleteAccount(){
        let user = Auth.auth().currentUser
        let deleteAlert = UIAlertController(title: "Delete Account?", message: "Do you wish to delete your account?", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            let secondAlert = UIAlertController(title: "Deleting Account", message: "Are You Sure There's no going back?", preferredStyle: UIAlertController.Style.alert)
            secondAlert.addAction(UIAlertAction(title: "Yes!!", style: .cancel, handler: { action in
                user?.delete(completion: nil)
                self.performSegue(withIdentifier: "loginScreenSegueIdentifier", sender: nil)
            }))
            self.present(secondAlert, animated: true, completion: nil)
            secondAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))

        }))
        deleteAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        present(deleteAlert, animated: true, completion: nil)

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
    
    func loadUserSettings(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        var fetchedResults: [NSManagedObject]? = nil
        let predicate = NSPredicate(format: "uid MATCHES '\(userID)'")
        request.predicate = predicate
        
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch{
            // error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        darkMode = fetchedResults![0].value(forKey: "darkmode") as! Bool
        screenSecurity = fetchedResults![0].value(forKey: "screensecurity") as! Bool
        
//        fetchedResults![0].setValue(false, forKey: "biometriclogin")
//        // Commit changes
//        do {
//            try context.save()
//        } catch {
//            // error occurs
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//            abort()
//        }
        
        let biometricLogin = fetchedResults![0].value(forKey: "biometriclogin") as! Bool
        darkModeSwitch.isOn = darkMode
        enableScreenSecuritySwitch.isOn = screenSecurity
        enableBiometricLoginSwitch.isOn = biometricLogin
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if darkMode{
            (tabBarController as! TabBarViewController).darkMode()
        } else if !darkMode {
            (tabBarController as! TabBarViewController).lightMode()
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
