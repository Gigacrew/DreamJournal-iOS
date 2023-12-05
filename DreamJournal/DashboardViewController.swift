//
//  DashboardViewController.swift
//  DreamJournal
//
//  Created by Eric Donnelly on 2023-08-03.
//

import UIKit
import CoreData

class DashboardViewController : UIViewController{
    
    var user : UserTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func OnViewAllClicked(_ sender: Any) {
        performSegue(withIdentifier: "ToListView", sender: user)
    }
    
    @IBAction func onProfileButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "ToProfile", sender: user)
    }
    
    @IBAction func onAddButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddEditDream", sender: user)
    }
    
    
}

