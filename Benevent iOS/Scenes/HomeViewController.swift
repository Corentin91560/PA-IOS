//
//  HomeViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Disconnect: UIButton!
    var connectedAsso: Association?
    
    @IBAction func Disconnect(_ sender: Any) {
//        let LoginPage = LoginViewController()
//        self.navigationController?.pushViewController(LoginPage, animated: true)
        // Returns the popped controller to the previous.
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true;
        super.viewDidLoad()
        tabBar.selectedItem = tabBar.items?[0]
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
