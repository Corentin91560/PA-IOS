//
//  AppConfig.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 30/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

struct AppConfig {
    static var apiURL: String = "http://localhost:3000"
    static var basicAssociationLogoURL: String = "https://nsa40.casimages.com/img/2020/06/25/200625031832328875.png"
    static var basicUserPictureURL: String = "https://nsa40.casimages.com/img/2020/07/07/200707114302299280.png"
    static let cloudinaryConfig = CLDConfiguration(cloudinaryUrl: "cloudinary://996546549428271:zTYYc7JGVOE4lpiWuyt5zSt_Ftc@beneventesgi")
    static let cloudinary = CLDCloudinary(configuration: AppConfig.cloudinaryConfig!)
}
