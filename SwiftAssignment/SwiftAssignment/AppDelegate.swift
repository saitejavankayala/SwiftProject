//
//  AppDelegate.swift
//  SwiftAssignment
//
//  Created by MA-31 on 20/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        if let url = RealmUserStatsStore().getDataBaseUrl(){
            print("Database URl", url)
        }
        // Override point for customization after application launch.
        return true
    }
}

