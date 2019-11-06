//
//  AppDelegate.swift
//  Bema
//
//  Created by Syed ShahRukh Haider on 01/10/2019.
//  Copyright © 2019 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userSnapDetail : User?
    var signInStatus = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // ********* FIREBASE *****
        
        FirebaseApp.configure()
        
        
        //******** IQKEYBOARD ********
        IQKeyboardManager.shared.enable = true
        
        
        //********** SEGUE IF ALREADY SIGN-IN ********
        
        self.signInStatus = UserDefaults.standard.bool(forKey: "SIGN_IN")
        
        print(self.signInStatus)
        
        if self.signInStatus == true{
            
            let userDetail = UserDefaults.standard.dictionary(forKey: "USER") as! [String:String]
            
            let usr = User.userDetail
            usr.imageUrl = userDetail["Image"]
            usr.displayName = userDetail["Name"]
            usr.userId = userDetail["Id"]
            
            userSnapDetail = usr
   
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "Tab_Controller") as! UITabBarController
            self.window?.rootViewController = mainVC
        }
        
        
        
       
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          
          return SCSDKLoginClient.application(app, open: url, options: options)
      }
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

