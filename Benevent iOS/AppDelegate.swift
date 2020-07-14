//
//  AppDelegate.swift
//  N3twørk
//
//  Created by Benoit Briatte on 13/12/2019.
//  Copyright © 2019 ESGI. All rights reserved.
//

import UIKit
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        let w = UIWindow(frame: UIScreen.main.bounds)
        let keychain = KeychainSwift()
        
        if(keychain.get("userEmail") != nil) {
            //keychain.set("ape", forKey: "userPassword")
            let assoWS: AssociationWebService = AssociationWebService()
            let postWS: PostWebService = PostWebService()
            let eventWS: EventWebService = EventWebService()
            let userWS: UserWebService = UserWebService()
            
            assoWS.Login(mail: keychain.get("userEmail")!, password: keychain.get("userPassword")!) { (asso) in
                print(keychain.get("userEmail")!)
                print(keychain.get("userPassword")!)
                if(asso.count > 0) {
                    postWS.getPosts(idAsso: asso[0].idas!) { (posts) in
                        eventWS.getEventsByAssociation(idAsso: asso[0].idas!) { (events) in
                            userWS.getUsersByIdAsso(idAsso: asso[0].idas!) { (users) in
                                w.rootViewController = UINavigationController(rootViewController: HomeViewController.newInstance(posts: posts, connectedAsso: asso[0], events: events, users: users))
                                w.makeKeyAndVisible()
                                self.window = w
                            }
                        }
                    }
                } else {
                    w.rootViewController = UINavigationController(rootViewController: LoginViewController())
                }
            }
            return true
        }
        
        w.rootViewController = UINavigationController(rootViewController: LoginViewController())
        w.makeKeyAndVisible()
        self.window = w
        return true
    }
}

