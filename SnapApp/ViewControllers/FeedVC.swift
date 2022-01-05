//
//  FeedVC.swift
//  SnapApp
//
//  Created by MEWO on 22.12.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let fireStoreDatabase =  Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 getUserInfo()

    }
 
    func getUserInfo(){
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { (snapshot, error) in
            if error != nil{
                self.makeAlert(title: "this is error alert", message: "check your info")
            }else{
                if snapshot?.isEmpty == true && snapshot == nil {
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String{
                            UserSingleton.sharedUserInfo.email = (Auth.auth().currentUser?.email)!
                            UserSingleton.sharedUserInfo.username = username
                            
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

}
