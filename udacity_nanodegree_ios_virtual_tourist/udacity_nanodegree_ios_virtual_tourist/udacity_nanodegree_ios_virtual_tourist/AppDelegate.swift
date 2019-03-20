//
//  AppDelegate.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 25/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserPreferences.initDefaults()
        return true
    }

}

