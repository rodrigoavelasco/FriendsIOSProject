//
//  ChangePasswordViewController.swift
//  Friends
//
//  Created by Rodrigo Velasco on 7/9/20.
//  Copyright © 2020 Rodrigo Velasco. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var confirmChangeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isDarkMode() {
            overrideUserInterfaceStyle = .dark
        } else{
            overrideUserInterfaceStyle = .light
        }
        customizeButtonBlue(button: confirmChangeButton)
    }
    @IBAction func confirmButtonPressed(_ sender: Any) {
    }
    
    func customizeButtonBlue(button:UIButton){
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    
    func isDarkMode() -> Bool {
        let userID = (Auth.auth().currentUser?.uid) ?? ""
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
        return fetchedResults![0].value(forKey: "darkmode") as! Bool
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
