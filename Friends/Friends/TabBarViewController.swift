//
//  TabBarViewController.swift
//  Friends
//
//  Created by Andrew Kim on 6/30/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class TabBarViewController: UITabBarController {
    
    
    let userEmail:String = (Auth.auth().currentUser?.email)!
    let useruid:String = (Auth.auth().currentUser?.uid)!

    override func viewDidLoad() {
        super.viewDidLoad()
        if isDarkModeOn(){
            darkMode()
        }
        // Do any additional setup after loading the view.
//        self.tabBarController?.tabBar.items![1].image = UIImage(named: "Home.png")
//        self.tabBarController?.tabBar.items![2].image = UIImage(named: "settings2.png")
    }
    
    func isDarkModeOn() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        var fetchedResults: [NSManagedObject]? = nil
        let predicate = NSPredicate(format: "email MATCHES '\(userEmail)'")
        request.predicate = predicate
        
        do{
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch{
            // error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        if fetchedResults!.count >= 1 {
            return (fetchedResults![0].value(forKey: "darkmode") != nil)
        } else {
            let user = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: context)
            user.setValue(userEmail, forKey: "email")
            user.setValue(useruid, forKey: "uid")
            user.setValue(false, forKey: "darkmode")
            user.setValue(true, forKey: "screensecurity")
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            return false
        }
    }
    
    func darkMode(){
        overrideUserInterfaceStyle = .dark
    }
    
    func screenSecurity(){
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = window!.frame
//        blurEffectView.tag = 221122
//        self.window?.addSubview(blurEffectView)

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
