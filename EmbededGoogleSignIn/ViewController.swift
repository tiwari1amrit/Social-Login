//
//  ViewController.swift
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

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnInstragram: UIButton!
    @IBOutlet weak var btnLinkedIn: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "961150475275-40k4pb22ro5de0ihurmt3botfb1u823l.apps.googleusercontent.com"
        
    }
    
     //MARK:-Google sign in Delegate
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print(email)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    @IBAction func btnLoginWithGoogleTouched(_ sender: Any) {
//        self.appDelegate.loginThroughApp = loginProcessBy.google
        GIDSignIn.sharedInstance().signIn()
        //        GIDSignIn.sharedInstance().signOut()
    }
    
    
    @IBAction func btnTwitterLoginTouched(_ sender: Any) {
        
        Twitter.sharedInstance().logIn { (session, error) in
            
            if (session != nil) {
                print("signed in as \(session?.userName)")
                let userID = session?.userID
                let authToken = session?.authToken
                let userName = session?.userName
                let authTokenSecret = session?.authTokenSecret
                
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
    }
    
     //MARK:- Facebook login
    @IBAction func btnLoginWithFacebookTouched(_ sender: Any) {
        
//        self.appDelegate.loginThroughApp = loginProcessBy.facebook

        if (FBSDKAccessToken.current() != nil){
            self.getFacebookUserData()
            
        }else{
            let permission = ["public_profile", "email", "user_friends"]
            //            ["user_photos"]
            FBSDKLoginManager().logIn(withReadPermissions: permission, from: self) { (result, error) in
                if (error != nil){
                    print(error?.localizedDescription)
                }
                if let result = result{
                    if result.isCancelled{
                        
                    }else{
                        
                        self.getFacebookUserData()
                    }
                }else{
                    
                }
            }
        }
    }
    
    func getFacebookUserData(){
        
        let parameters = ["fields": "email, first_name, last_name, picture,birthday, photos.limit(2)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start {  (connection, users, requestError) -> Void in
            if requestError != nil {
                
                return
            }
            
            if let user = users as? [String:AnyObject]{
                print(user)
                let firstName = user["first_name"] as? String
                let lastName = user["last_name"] as? String
                let email = user["email"] as? String
                let id = user["id"] as? String
                print(id)
                if let picURL = ((user["picture"] as? [String:AnyObject])?["data"] as? [String:AnyObject])?["url"] as? String{
                    print(picURL)
                }
            }
            
        }
        
    }
    
     //MARK:- Instragram Login
    
    @IBAction func btnLoginWithInstragramTouched(_ sender: Any) {
//        self.appDelegate.loginThroughApp = loginProcessBy.instragram
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginWithInstragramViewController") as! LoginWithInstragramViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //self.present(vc, animated: true, completion: nil)

    }
    
     //MARK:- LinkedIn login
    @IBAction func btnLoginWithLinkedInTouched(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LinkedInViewController") as! LinkedInViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//enum loginProcessBy : String{
//    case facebook = "facebook"
//    case instragram = "instragram"
//    case google = "google"
//    case linkedIn = "linkedIn"
//    case twitter = "twitter"
//}

enum loginProcessBy : CustomStringConvertible {
    case facebook
    case instragram
    case google
    case linkedIn
    case twitter
    
    var description : String {
        
        switch self {
            
        case .facebook: return "facebook"
        case .instragram: return "instragram"
        case .google: return "google"
        case .linkedIn: return "linkedIn"
        case .twitter: return "twitter"
        }
    }
}
