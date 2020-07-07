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
        w.rootViewController = UINavigationController(rootViewController: LoginViewController())
        w.makeKeyAndVisible()
        self.window = w

        return true
    }
}

