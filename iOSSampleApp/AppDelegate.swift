//
//  AppDelegate.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 03/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import os.log
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        #if DEBUG
        if ProcessInfo().arguments.contains("testMode") {
            os_log("Running in UI tests, deleting selected source to start clean", log: OSLog.lifeCycle, type: .debug)
            Current.settings.setSelectedSource(nil)
        }
        #endif

        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()

        window?.makeKeyAndVisible()

        return true
    }
}
