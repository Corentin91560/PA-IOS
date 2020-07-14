//
//  EventQRViewController.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 07/07/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import UIKit
import CoreImage

class EventQRViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var QRCodeImageView: UIImageView!

    var event: Event!
    var qrcodeImage: CIImage? {
      didSet {
        if let image = qrcodeImage {
            QRCodeImageView.image = UIImage(ciImage: image)
        }
        else {
            QRCodeImageView.image = nil
        }
      }
    }
    
    class func newInstance(event: Event) -> EventQRViewController {
        let EventQRVC: EventQRViewController = EventQRViewController()
        EventQRVC.event = event
        return EventQRVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 20
        setupNavigationBar()
        updateQRCodeImageWithText(text: String(event.idev!))
    }
    
    func setupNavigationBar() {
         // Navigation bar main config
          self.navigationItem.hidesBackButton = true
          self.navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
          self.navigationItem.title = "\(event!.name)"
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
          // Left item config
          self.navigationItem.leftBarButtonItem = UIBarButtonItem(
              image: UIImage(named: "SF_multiply_circle_fill"),
              style: .plain,
              target: self,
              action: #selector(Back))
          self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
          
      }
    
    @objc func Back() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func updateQRCodeImageWithText(text: String) {
        if let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false),
         let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("L", forKey: "inputCorrectionLevel")

        qrcodeImage = filter.outputImage
      }
    }
}
