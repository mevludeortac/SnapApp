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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase =  Firestore.firestore()
    //tableview içerisine alacağımızdan ötürü, içerisine snap objelerimizi koyacağımız bi dizi oluşturuyoruz.
    var snapArray = [Snap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getSnapsFromFirebase()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.usernameFeed.text = snapArray[indexPath.row].username
        return cell
    }
    
    func getSnapsFromFirebase(){
        //descending: güncel olana göre sırala
        //addData yerine snapshot kullanmamızın sebebi: her değişiklik olduğunda güncellenip üzerine veri eklenmesini istememiz
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil{
                    //dökümanları almaya başlıyoruz
                    //for loop'a girmeden snapArrayi temizliyoruz
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("username") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    //24 saatlik sayaç
                                    //kaydedilen date.dateValue'dan güncel Date arasında
                                    if let differenceHour = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if differenceHour >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete()
                                        }else{
                                            //timeleft -> SnapVC
                                        }
                                    }
                                    
                                    let snap = Snap(username: username, imageUrl: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
