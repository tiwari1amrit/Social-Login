//
//  LinkedInViewController.swift
//  Fancy
//
//  Created by farheen banu on 5/4/17.
//  Copyright © 2017 Farheen Banu. All rights reserved.
//

import UIKit

class LinkedInViewController: UIViewController , UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    // constants
    let linkedInKey = "86i03cjuyks3ds"
    
    let linkedInSecret = "Ch0fVoj1MwS0ClX2"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        startAuthorization()
        print(accessTokenEndPoint)
        // Do any additional setup after loading the view.
    }

    func startAuthorization(){
        let responseType = "code"
        let redirectURL = "http://esignature.com.np".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile"
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL!)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        // Create a URL request and load it in the web view.

        let request = NSURLRequest(url: NSURL(string: authorizationURL)! as URL)
        webView.loadRequest(request as URLRequest)
//        

    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url
        print("URL: \(url)")
        if url?.host == "esignature.com.np" {
            if url?.absoluteString.range(of: "code") != nil {
                //extract code
                let urlParts = url?.absoluteString.components(separatedBy: "?")
                print("URLPARTS : \(urlParts)")
                let code = urlParts?[1].components(separatedBy: "=")[1]
                print("CODE : \(code)")
                requestForAccessToken(authorizationCode: code!)
                
            }
        }
        
        return true
    }
    
    
    func requestForAccessToken(authorizationCode: String){
        let grantType = "authorization_code"
        let redirectUrl = "http://esignature.com.np".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectUrl!)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        print(postParams)
        let postData = postParams.data(using: .utf8)
       
        
        var request = URLRequest(url: URL(string: accessTokenEndPoint)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        _ = URLSessionConfiguration.default
        let session = URLSession.shared
        print(request)
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, res, error) in
            let statusCode = (res as! HTTPURLResponse).statusCode
            print(statusCode)
            if statusCode == 200 {
                do {
                    let dataDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                    let accessToken = dataDict?["access_token"] as! String
                    print(accessToken)
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        _ = self.dismiss(animated: true, completion: nil)
                    }
                    
                } catch {
                    print("Couldnot convert")
                }
            }
        }
        task.resume()
    }
    

}
