//
//  AddJournalEntryViewController.swift
//  DreamJournal
//
//  Created by Eric Donnelly on 2023-06-12.
//

import Foundation
import UIKit
import CoreData
import FirebaseFirestore
import FirebaseAuth

class AddJournalEntryViewController : UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var feelingsTextField: UITextField!
    @IBOutlet weak var recurringSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dream : Dream?
    var userId: String?
    
    // Create instance of UI Image Picker
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Declare the delegate for the image picker is our
            imagePicker.delegate = self
            
            // Setup the view if editing an existing dream
            if let dream = dream {
                titleTextField.text = dream.title
                descriptionTextView.text = dream.dreamDescription
                categoriesTextField.text = dream.category
                feelingsTextField.text = dream.feeling.joined(separator: ", ")  // Join feelings into a string
                recurringSwitch.isOn = dream.recurringDream
                datePicker.date = dream.date ?? Date()
            }
            
            // Get the current user's userId from Firebase Auth
            userId = Auth.auth().currentUser?.uid
        }
    
    @IBAction func BackButtonPushed (_ sender: Any){
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func ConfirmButtonPushed (_ sender: Any){
        guard let userId = userId else {
                    print("No user ID available")
                    return
                }
                
                let title = titleTextField.text ?? ""
                let dreamDescription = descriptionTextView.text ?? ""
                let category = categoriesTextField.text ?? ""
                let feelings = feelingsTextField.text?.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
                let recurringDream = recurringSwitch.isOn
                let date = datePicker.date
                
                let dreamToUpdate = Dream(
                    dreamId: dream?.dreamId,
                    title: title,
                    dreamDescription: dreamDescription,
                    userId: userId,
                    date: date,
                    feeling: feelings,
                    category: category,
                    recurringDream: recurringDream,
                    imageURL: ""  // Set the actual image URL if you have one
                )
                
                saveDream(dreamToUpdate)
                navigationController?.popViewController(animated: true)
            }
            
    func saveDream(_ dream: Dream) {
        let db = Firestore.firestore()
        print(dream.dreamId ?? "No Dream Id found")
        if let dreamId = dream.dreamId {
            // Update existing dream
            do {
                
                try db.collection("dreams").document(dreamId).setData(from: dream) { error in
                    if let error = error {
                        print("Error updating dream: \(error)")
                    } else {
                        print("Dream successfully updated")
                    }
                }
            } catch let error {
                print("Error setting data: \(error)")
            }
        } else {
            // Add a new dream
            do {
                let _ = try db.collection("dreams").addDocument(from: dream) { error in
                    if let error = error {
                        print("Error adding new dream: \(error)")
                    } else {
                        print("New dream added successfully")
                    }
                }
            } catch let error {
                print("Error adding new dream: \(error)")
            }
        }
    }
    
    
    @IBAction func chooseImgButtonPushed (_ sender: Any) {
        present(imagePicker,animated:true,completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        // TODO: Process the selected image here
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //TODO: Handle cancel event if needed
    }
    
    
}
