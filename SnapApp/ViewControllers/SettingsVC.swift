//
//  SettingsVC.swift
//  SnapApp
//
//  Created by MEWO on 22.12.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func settingsButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch  {
            
        }
    }
}
