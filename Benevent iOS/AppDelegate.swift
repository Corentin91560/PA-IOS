//
//  AppDelegate.swift
//  Benevent iOS
//
//  Created by Thomas MARTIN on 17/05/2020.
//  Copyright © 2020 Benevent. All rights reserved.
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
            let assoWS: AssociationWebService = AssociationWebService()
            let postWS: PostWebService = PostWebService()
            let eventWS: EventWebService = EventWebService()
            let userWS: UserWebService = UserWebService()
            var checkCallback = false
            assoWS.Login(mail: keychain.get("userEmail")!, password: keychain.get("userPassword")!) { (asso) in
                checkCallback = true
                if(asso.count > 0 || checkCallback) {
                    postWS.getPosts(idAsso: asso[0].idAssociation!) { (posts) in
                        if(posts.isEmpty == false) {
                            eventWS.getEventsByAssociation(idAsso: asso[0].idAssociation!) { (events) in
                                userWS.getUsersByIdAsso(idAsso: asso[0].idAssociation!) { (users) in
                                    w.rootViewController = UINavigationController(rootViewController: HomeViewController.newInstance(posts: posts, connectedAsso: asso[0], events: events, users: users))
                                    w.makeKeyAndVisible()
                                    self.window = w
                                }
                            }
                        }
                    }
                } else {
                    w.rootViewController = UINavigationController(rootViewController: LoginViewController())
                    w.makeKeyAndVisible()
                    self.window = w
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

