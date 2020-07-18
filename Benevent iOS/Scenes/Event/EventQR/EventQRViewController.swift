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

    private var event: Event!
    
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var QRCodeImageView: UIImageView!
    
    private var qrcodeImage: CIImage? {
      didSet {
        if let image = qrcodeImage {
            let scaleX = QRCodeImageView.frame.size.width / qrcodeImage!.extent.size.width
            let scaleY = QRCodeImageView.frame.size.height / qrcodeImage!.extent.size.height
            let transformedImage = image.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            QRCodeImageView.image = UIImage(ciImage: transformedImage)
        }
        else {
            QRCodeImageView.image = nil
        }
      }
    }
    
    class func newInstance(event: Event) -> EventQRViewController {
        let eventQRVC: EventQRViewController = EventQRViewController()
        eventQRVC.event = event
        return eventQRVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        backgroundView.layer.cornerRadius = 20
        setupNavigationBar()
        updateQRCodeImageWithText(text: String(event.getIdEvent()))
    }
    
    private func setupNavigationBar() {
          navigationItem.hidesBackButton = true
          navigationController?.navigationBar.barTintColor = UIColor(named: "NavigationBackgroundColor")
          navigationItem.title = "\(event!.getName())"
          navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Monofonto-Regular", size: 25)!]
          navigationItem.leftBarButtonItem = UIBarButtonItem(
              image: UIImage(named: "SF_multiply_circle_fill"),
              style: .plain,
              target: self,
              action: #selector(Back))
          navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc private func Back() {
        navigationController?.popViewController(animated: false)
    }
    
    private func updateQRCodeImageWithText(text: String) {
        if let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false),
            let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                filter.setValue("L", forKey: "inputCorrectionLevel")
                qrcodeImage = filter.outputImage
            }
    }
}
