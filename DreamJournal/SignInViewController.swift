//
//  ViewController.swift
//  DreamJournal
//
//  Created by Jaivleen Kour on 2023-06-10.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore


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
  
    
    @IBAction func LoginBtnPressed(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else {
            print("Please enter both username and password.")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
          .whereField("username", isEqualTo: username)
          .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                self.displayErrorMessage(message: "Error fetching user details")
            } else if let snapshot = snapshot, snapshot.documents.count > 0 {
                // Assuming username is unique and fetches the first document
                if let document = snapshot.documents.first,
                   let email = document.data()["email"] as? String {
                    
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                        if let error = error {
                            print("Login failed: \(error.localizedDescription)")
                            self.displayErrorMessage(message: "Authentication Failed")
                        } else {
                            print("User logged in successfully.")
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "ToDashboard", sender: nil)
                            }
                        }
                    }
                } else {
                    print("Email not found for the given username.")
                    self.displayErrorMessage(message: "Invalid Username")
                }
            } else {
                print("Username does not exist.")
                self.displayErrorMessage(message: "Invalid Username")
            }
        }
    }
    
    func displayErrorMessage(message: String)
        {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.ClearLoginTextFields() // Clear text fields and set focus to username
            })
            
            DispatchQueue.main.async
            {
                self.present(alertController, animated: true)
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
