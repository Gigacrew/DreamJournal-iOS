import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class DreamTableViewController: UITableViewController {
    var dreamList: [Dream] = []  // Updated to use Dream instead of DreamEntryTable
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDreamsFromFirestore()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDreamsFromFirestore()
    }
    
    func fetchDreamsFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
                print("No user is currently logged in.")
                return
            }

        let db = Firestore.firestore()
        db.collection("dreams")
          .whereField("userId", isEqualTo: userId)  // Assuming the userId field is correct
          .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            var fetchedDreams: [Dream] = []  // Use Dream here
            
            for document in snapshot!.documents {
                do {
                    var dream = try document.data(as: Dream.self)// Use Codable to decode
                    dream.dreamId = document.documentID
                    fetchedDreams.append(dream)
                } catch {
                    print("Error decoding dream: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                self.dreamList = fetchedDreams
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dreamList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DreamEntry", for: indexPath) as! DreamTableViewCell
        let dream = dreamList[indexPath.row]
        
        // Ensure that the properties match the Dream struct
        cell.titleLabel?.text = dream.title.capitalized
        cell.descriptionLabel?.text = dream.dreamDescription.capitalized
        
        // Format the date to display it in the cell
        if let date = dream.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.dateLabel?.text = formatter.string(from: date)
        } else {
            cell.dateLabel?.text = "Date not available"
        }

        return cell
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "AddEditDream", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "AddEditDream"
        {
            if let addEditVC = segue.destination as? AddJournalEntryViewController
            {
                if let indexPath = sender as? IndexPath
                {
                   // Editing existing movie
                   let dream = dreamList[indexPath.row]
                   addEditVC.dream = dream
                } else {
                    // Adding new movie
                    addEditVC.dream = nil
                }
            }
        }
    }
  
}
