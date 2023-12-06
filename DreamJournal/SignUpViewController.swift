//
//  SignUpVC.swift
//  DreamJournalApp
//
//  Created by Supreet on 2023-07-16.


import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var userCount:Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    
//    func saveUserDataToJSON() {
//        
//           let userData: [String: String] = [
//            "email": emailTextField.text ?? "",
//            "username": usernameTextfield.text ?? "",
//            "password": passwordTextField.text ?? "",
//            "firstName": firstNameTextField.text ?? "",
//            "lastName": lastNameTextField.text ?? "",
//            "phoneNumber": phoneNumberTextField.text ?? ""
//        ]
//           
//           if let fileURL = Bundle.main.url(forResource: "users", withExtension: "json") {
//               do {
//                   // Read the existing JSON data from the file
//                   let jsonData = try Data(contentsOf: fileURL)
//                   
//                   // Deserialize the JSON data into an array of dictionaries
//                   var jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] ?? []
//                   
//                   jsonArray.append(userData)
//                   
//                   let updatedJsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
//                   
//                   try updatedJsonData.write(to: fileURL)
//                   
//                   print("User data saved to 'users.json' successfully.")
//               } catch {
//                   print("Error writing to 'users.json': \(error)")
//               }
//           } else {
//               print("Failed to get URL for 'users.json' in the main bundle.")
//           }
//       }
//    func getUserIDInfo(){
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest: NSFetchRequest<UserTable> = UserTable.fetchRequest()
//        do {
//            let users = try context.fetch(fetchRequest)
//            print("Users count: ",users.count)
//            userCount = users.count
//        }
//        catch {
//            print("Failed to fetch Users: \(error)")
//        }
//    }
//    
//    func saveUserDataToCoreData() {
//           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//               return
//           }
//            getUserIDInfo()
//
//           let context = appDelegate.persistentContainer.viewContext
//           let newUser = UserTable(context: context)
//           newUser.email = emailTextField.text
//           newUser.username = usernameTextfield.text
//           newUser.password = passwordTextField.text
//           newUser.firstName = firstNameTextField.text
//           newUser.lastName = lastNameTextField.text
//           newUser.phoneNumber = phoneNumberTextField.text
//        
//           newUser.user_id = Int16(userCount + 1)
//
//           do {
//               try context.save()
//               print("User data saved to Core Data successfully.")
//           } catch {
//               print("Failed to save user data to Core Data: \(error)")
//           }
//       }

    @IBAction func CreateUser(_ sender: Any) {
        guard let username = usernameTextfield.text,
                      let email = emailTextField.text,
                      let password = passwordTextField.text,
                      let confirmPassword = confirmPasswordTextField.text,
                      let firstName = firstNameTextField.text,
                      let lastName = lastNameTextField.text,
                      let phoneNumber = phoneNumberTextField.text,
                      password == confirmPassword else {
                    print("Please enter valid email and matching passwords.")
                    return
                }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Registration failed: \(error.localizedDescription)")
                        self.displayErrorMessage(message: "\(error.localizedDescription)")
                        return
                    }
            print("Inside Create User")

                    // Store the username and email mapping in Firestore
                    let db = Firestore.firestore()
                    db.collection("usernames").document(username).setData(["email": email]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }

                    print("User registered successfully.")
                     // User registration success
                    guard let user = authResult?.user else { return }
                    
                    // Save additional user information to Firestore
                    let userId = user.uid
                    let userMap: [String: Any] = [
                        "username": username,
                        "firstname": firstName,
                        "lastname": lastName,
                        "email": email,
                        "phoneNumber": phoneNumber
                    ]
            // Store user information in Firestore
                    db.collection("users").document(userId).setData(userMap) { error in
                        if let error = error {
                            print("Error adding user information to Firestore: \(error.localizedDescription)")
                            // TODO: Handle registration failure
                        } else {
                            print("User information added to Firestore.")
                            // TODO: Handle successful registration and navigation
                        }
                    }                                                  
                    DispatchQueue.main.async {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        
        
    }
     func displayErrorMessage(message: String)
        {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            })
            
            DispatchQueue.main.async
            {
                self.present(alertController, animated: true)
            }
        }
    
    
    
}
