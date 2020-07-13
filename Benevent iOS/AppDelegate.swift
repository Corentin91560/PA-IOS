//
//  AppDelegate.swift
//  N3twørk
//
//  Created by Benoit Briatte on 13/12/2019.
//  Copyright © 2019 ESGI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
        let w = UIWindow(frame: UIScreen.main.bounds)
        
        if(UserDefaults.standard.bool(forKey: "isLogged")) {
            let assoWS: AssociationWebService = AssociationWebService()
            let postWS: PostWebService = PostWebService()
            let eventWS: EventWebService = EventWebService()
            let userWS: UserWebService = UserWebService()
            
            assoWS.Login(mail: UserDefaults.standard.string(forKey: "userEmail")!, password: UserDefaults.standard.string(forKey: "userPassword")!) { (asso) in
                if(asso.count > 0) {
                    postWS.getPosts(idAsso: asso[0].idas!) { (posts) in
                        eventWS.getEventsByAssociation(idAsso: asso[0].idas!) { (events) in
                            userWS.getUsers { (users) in
                                w.rootViewController = UINavigationController(rootViewController: HomeViewController.newInstance(posts: posts, connectedAsso: asso[0], events: events, users: users))
                            }
                        }
                    }
                } else {
                    w.rootViewController = UINavigationController(rootViewController: LoginViewController())
                }
            }
        }
        
        w.rootViewController = UINavigationController(rootViewController: LoginViewController())
        w.makeKeyAndVisible()
        self.window = w
        return true
    }
}

