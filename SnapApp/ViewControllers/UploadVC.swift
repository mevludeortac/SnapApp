//
//  UploadVC.swift
//  SnapApp
//
//  Created by MEWO on 22.12.2021.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chosePicture))
        imageView.addGestureRecognizer(gestureRecognizer)
    
    }
    @IBAction func uploadClicked(_ sender: Any) {
        
        
        //STORAGE
            
        let storage = Storage.storage()
        let storageReference = storage.reference()
        //görselleri koyacağımız klasörü oluşturuyoruz
        let mediaFolder = storageReference.child("media")
        //görselimizi veriye çeviriyoruz
        if  let data  = imageView.image?.jpegData(compressionQuality: 0.5){
        let uuid = UUID().uuidString
        let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error == nil {
                    imageReference.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl  = url?.absoluteString
                            
                            //FIRESTORE
                            
                            let firestore = Firestore.firestore()
                            
                            //snapOwner'ın daha önce kaydettiği snapleri var mı onu kontrol ediyoruz
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    self.makeAlert(title: "error", message: error!.localizedDescription)

                                }
                                //snapOwner'ın daha önce kaydettiği başka bi döküman varsa o dökümanı alıp içerisine yeni gönderilen imageUrl'i ekliyoruz
                                else{
                                    if snapshot?.isEmpty == false && snapshot != nil{
                                        for document in snapshot!.documents{
                                            let documentId = document.documentID
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String: Any]
                                                //yeni eklenen imageurl'i ekliyoruz
                                                //merge: eski değerleri tut ve üzerine ekle
                                                firestore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                    if error == nil{
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "click")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        let snapDictionary =  ["imageUrlArray": [imageUrl!], "snapOwner": UserSingleton.sharedUserInfo.username, "date": FieldValue.serverTimestamp()] as [String: Any]
                                        firestore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                            if error == nil{
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "click")
                                            }
                                            else{
                                                self.makeAlert(title: "error", message: error!.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                    }
                }
                else{
                    self.makeAlert(title: "error", message: "checkkk")
                }
            }
        }
        
    }
    
   @objc  func chosePicture(){
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    self.present(picker, animated: true, completion: nil)
   }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func makeAlert(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
