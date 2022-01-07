//
//  SnapVC.swift
//  SnapApp
//
//  Created by MEWO on 23.12.2021.
//

import UIKit
import ImageSlideshow
import Kingfisher
class SnapVC: UIViewController {

    @IBOutlet weak var timeLeft: UILabel!
    
     
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let snap = selectedSnap {
            timeLeft.text = "Time Left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
                
                }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.8))
            imageSlideShow.backgroundColor = UIColor.purple

            //INDICATOR
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            imageSlideShow.pageIndicator = pageIndicator
            
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLeft)
        }
        
       

    }
    

}
