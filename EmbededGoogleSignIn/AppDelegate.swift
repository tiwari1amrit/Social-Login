//
//  AppDelegate.swift
//  EmbededGoogleSignIn
//
//  Created by Amrit on 1/20/17.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import GoogleSignIn
import TwitterKit
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //google sign in
        GIDSignIn.sharedInstance().delegate = self
        
        //twitter sign in
        Twitter.sharedInstance().start(withConsumerKey:"t4QR0UVLi9CnBtbe3esUBKTgl", consumerSecret:"Hj9z4LEIZoOQ9QhIHUIsdg8DnEz1LcONsb4OpuLqn1MIyOLJqb")
        
        //facebook sign in 
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate : GIDSignInDelegate{
    
//    @objc(application:openURL:sourceApplication:annotation:)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)

        let googleHandler = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return facebookHandler || googleHandler
  
  }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)

        let twitterHandler = Twitter.sharedInstance().application(app, open: url, options: options)
        
        //for returning the google call back url
        let googleHandler = GIDSignIn.sharedInstance().handle(url, sourceApplication: "com.apple.SafariViewService", annotation: nil)
        
        return facebookHandler || twitterHandler || googleHandler
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
   
    
}



//        if self.loginThroughApp == loginProcessBy.facebook{
//
//            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//        }else if self.loginThroughApp == loginProcessBy.twitter{
//
//            return true
//        }else if self.loginThroughApp == loginProcessBy.google{
//
//            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        }else if self.loginThroughApp == loginProcessBy.instragram{
//
//            return true
//        }else if self.loginThroughApp == loginProcessBy.linkedIn{
//
//            return true
//        }else{
//            return false
//        }





//        if self.loginThroughApp == loginProcessBy.facebook{
//
//            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//        }else if self.loginThroughApp == loginProcessBy.twitter{
//
//            return Twitter.sharedInstance().application(app, open: url, options: options)
//        }else if self.loginThroughApp == loginProcessBy.google{
//
//            return true//GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//        }else if self.loginThroughApp == loginProcessBy.instragram{
//
//            return true
//        }else if self.loginThroughApp == loginProcessBy.linkedIn{
//
//            return true
//        }else{
//            return false
//        }

