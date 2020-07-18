//
//  UserFactory.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 31/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
//

import Foundation
import UIKit

class AssociationFactory {
    
    static func associationFrom(dictionary: [String: Any]) -> Association? {
        guard let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String,
              let password = dictionary["password"] as? String else {
                return nil
        }
        let asso =  Association(name: name, email: email, password: password)
        
        asso.setLogo(logo: dictionary["logo"] as? String ?? AppConfig.basicAssociationLogoURL)
        asso.setIdAssociation(idAssociation: dictionary["idassociation"] as! Int)
        asso.setIdCategory(idCategory: dictionary["idcategory"] as! Int)
        asso.setAcronym(acronym: dictionary["acronym"] as? String)
        asso.setPhone(phone: dictionary["phone"] as? String)
        asso.setWebsite(website: dictionary["website"] as? String)
        asso.setSupport(support: dictionary["support"] as? String)
        return asso
    }
    
    static func dictionnaryFrom(asso: Association) -> [String: Any] {
          return [
            "name": asso.getName(),
            "email": asso.getEmail(),
            "phone": asso.getPhone() ?? "",
            "website": asso.getWebsite() ?? "",
            "acronym": asso.getAcronym() ?? "",
            "logo": asso.getLogo(),
            "support": asso.getSupport() ?? "",
        ]
      }
    
}
