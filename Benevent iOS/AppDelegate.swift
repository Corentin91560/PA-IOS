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

        let w = UIWindow(frame: UIScreen.main.bounds)
        
        if(AppConfig.keychain.get("userEmail") != nil) {
            let assoWS: AssociationWebService = AssociationWebService()
            let postWS: PostWebService = PostWebService()
            let eventWS: EventWebService = EventWebService()
            let userWS: UserWebService = UserWebService()
            var checkCallback = false
            assoWS.Login(mail: AppConfig.keychain.get("userEmail")!, password: AppConfig.keychain.get("userPassword")!) { (asso) in
                if(asso.count > 0 || checkCallback) {
                    postWS.getPosts(idAsso: asso[0].getIdAssociation()) { (posts) in
                        eventWS.getEventsByAssociation(idAsso: asso[0].getIdAssociation()) { (events) in
                            userWS.getUsersByIdAsso(idAsso: asso[0].getIdAssociation()) { (users) in
                                checkCallback = true
                                AppConfig.connectedAssociation = asso[0]
                                w.rootViewController = UINavigationController(rootViewController: HomeViewController.newInstance(posts: posts, events: events, users: users))
                                w.makeKeyAndVisible()
                                self.window = w
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

