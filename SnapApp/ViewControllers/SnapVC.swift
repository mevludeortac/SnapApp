//
//  SnapVC.swift
//  SnapApp
//
//  Created by MEWO on 23.12.2021.
//

import UIKit

class SnapVC: UIViewController {

    @IBOutlet weak var timeLeft: UILabel!
     
    var selectedSnap : Snap?
    var selectedTimeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  let time = selectedTimeLeft {
            timeLeft.text = "Time Left: \(time)"

        }

    }
    

}
