import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        // Get the current user's UID
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    self.currentUser = try document.data(as: User.self)
                    self.updateUI()
                } catch {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.usernameTextField.text = self.currentUser?.username
            self.firstNameTextField.text = self.currentUser?.firstname
            self.lastNameTextField.text = self.currentUser?.lastname
            self.phoneNumberTextField.text = self.currentUser?.phoneNumber
        }
    }
    
    @IBAction func updateButton(_ sender: Any) {
        // Update the current user object
        currentUser?.username = usernameTextField.text ?? ""
        currentUser?.firstname = firstNameTextField.text ?? ""
        currentUser?.lastname = lastNameTextField.text ?? ""
        currentUser?.phoneNumber = phoneNumberTextField.text ?? ""

        // Update Firestore with the new user information
        guard let uid = Auth.auth().currentUser?.uid, let updatedUser = currentUser else { return }

        let db = Firestore.firestore()
        do {
            try db.collection("users").document(uid).setData(from: updatedUser)
            // Inform the user of success
            print("Profile successfully updated.")
        } catch let error {
            print("Error updating profile: \(error)")
        }
    }
    
}
