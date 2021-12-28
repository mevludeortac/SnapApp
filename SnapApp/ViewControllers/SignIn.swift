//
//  ViewController.swift
//  SnapApp
//
//  Created by MEWO on 20.12.2021.
//

import UIKit
import Firebase

class SignIn: UIViewController {

    @IBOutlet weak var eMailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if usernameTxt.text != nil && eMailTxt.text != nil && passwordTxt.text != nil{
            Auth.auth().signIn(withEmail: eMailTxt.text!, password: passwordTxt.text!) { (result, error) in
                if error != nil {
                        self.makeAlert(title: "ok", message: error!.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            
        }
        }else{
            self.makeAlert(title: "error", message: "be sure your info")
        }
        
    }
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameTxt.text != nil && eMailTxt.text != nil && passwordTxt.text != nil{
            //
            Auth.auth().createUser(withEmail: eMailTxt.text!, password: passwordTxt.text!) { (auth, error) in
                if error != nil{
                    self.makeAlert(title: "ok", message: error!.localizedDescription)
                }else{
                    let fireStore =
                        Firestore.firestore()
                    //veritabanındaki tablomuza
                    let userDictionary = ["email" : self.eMailTxt.text, "username" : self.usernameTxt.text] as [String : Any]
                    //veritabanında tablo oluşturma
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil{
                            
                        }
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
                
            }
            
        }else{
            makeAlert(title: "error", message: "you must be forgot email/username/password")
        }
    }
    
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

