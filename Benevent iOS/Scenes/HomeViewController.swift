//
//  HomeViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 25/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class HomeViewController: UIViewController {
    @IBOutlet var Firstname: UILabel!
    @IBOutlet var Email: UILabel!
    @IBOutlet var Picture: UIImageView!
    @IBOutlet var id: UILabel!
    @IBOutlet var Disconnect: UIButton!
    var connectedUser: User?
    var connectedWithFB : Int = 1
    
    @IBAction func Disconnect(_ sender: Any) {
        let LoginManager = FBSDKLoginKit.LoginManager()
        LoginManager.logOut()

        let LoginPage = LoginViewController()
        self.navigationController?.pushViewController(LoginPage, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
        if (connectedWithFB == 1) {
            guard let accessToken = FBSDKLoginKit.AccessToken.current else {return}
            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                          parameters: ["fields": "id, email, name"],
                                                          tokenString: accessToken.tokenString,
                                                          version: nil,
                                                          httpMethod: .get
                                                          )
            
            graphRequest.start{ (connection, result, error) -> Void in
                if (error == nil) {
                   
                    let dict: NSDictionary = result as! [String: AnyObject] as NSDictionary
                    
                    let userName = dict.object(forKey: "name") as! String
                    self.Firstname.text = userName
                    
                    let id = dict.object(forKey: "id") as! String
                    self.id.text = id
                    
                    
                    let userMail = dict.object(forKey: "email") as! String
                    self.Email.text = userMail
                    
                    let targetSize = CGSize.init(width: 450, height: 450)
                    let facebookPictureURL = URL(string: "http://graph.facebook.com/\(id)/picture?type=large")! as URL
                    if let imageData: NSData = NSData(contentsOf: facebookPictureURL) {
                        self.Picture.image = self.resizeImage(image: UIImage(data: imageData as Data)!, targetSize: targetSize)
                    }
                    
                } else {
                   
                }
            }
        } else {
            self.Firstname.text = connectedUser?.firstName
            self.Email.text = connectedUser?.email
            self.id.text = connectedUser?.id?.description
        }
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
