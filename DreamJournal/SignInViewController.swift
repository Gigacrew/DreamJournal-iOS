//
//  ViewController.swift
//  DreamJournal
//
//  Created by Jaivleen Kour on 2023-06-10.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var appleView: UIView!
    
    var receivedUsername: String?
    var receivedPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let username = receivedUsername, let password = receivedPassword {
            usernameTextField.text = username
            passwordTextField.text = password
        }
        
        for credentialsView in [self.emailView , self.passwordView]
        {
            credentialsView?.layer.borderColor = UIColor.lightGray.cgColor
            credentialsView?.layer.borderWidth = 1
            credentialsView?.layer.cornerRadius = 10
            credentialsView?.clipsToBounds = true
        }
        
        for views in [self.loginView, self.googleView , self.facebookView , self.appleView]
        {
            views?.layer.borderColor = UIColor.clear.cgColor
            views?.layer.borderWidth = 1
            views?.layer.cornerRadius = 10
            views?.clipsToBounds = true
        }
        
    }
    
    func ClearLoginTextFields()
    {
        usernameTextField.text = ""
        passwordTextField.text = ""
        usernameTextField.becomeFirstResponder()
    }
    
    
    
    
    @IBAction func LoginBtnPressed(_ sender: Any){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        guard let username = usernameTextField.text,
              let password = passwordTextField.text,
              !username.isEmpty, !password.isEmpty else {
            // Display an alert message if any field is empty
            let alert = UIAlertController(title: "Login Failed", message: "Username and password are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Create a fetch request to check if the user exists
        let fetchRequest: NSFetchRequest<UserTable> = UserTable.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username = %@ AND password = %@", username, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            
            if let user = users.first {
                print("Login Successful")
                // Successful login
                performSegue(withIdentifier: "ToDashboard", sender: user)
            } else {
                // Invalid credentials, display an error message
                let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } catch {
            // Handle the error appropriately (e.g., display an alert)
            print("Failed to fetch user: \(error)")
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToProfile" {
//            // Pass the user object to the ProfileViewController
//            if let profileVC = segue.destination as? ProfileViewController,
//               let user = sender as? UserTable {
//                // Set the user information properties in ProfileViewController
//                profileVC.username = user.username ?? ""
//                profileVC.firstName = user.firstname ?? ""
//                profileVC.lastName = user.lastname ?? ""
//                profileVC.phoneNumber = user.phone_number ?? ""
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDashboard" {
            if let navigationController = segue.destination as? UINavigationController,
               let dashboardVC = navigationController.topViewController as? DashboardViewController {
                if let user = sender as? UserTable {
                    dashboardVC.user = user
                }
            }
        }
    }
    
    @IBAction func forgotPassBtn(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in ", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Still using App")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { (action: UIAlertAction!) in
            print("Logged Out")
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    
    
}
