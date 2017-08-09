//
//  LoginWithInstragramViewController.swift
//  EmbededGoogleSignIn
//
//  Created by Amrit on 8/9/17.
//  Copyright © 2017 Amrit. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class LoginWithInstragramViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        unSignedRequest()
        // Do any additional setup after loading the view.
    }
    func unSignedRequest () {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE ])
        let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return checkRequestForCallbackURL(request: request)
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        
        print("Instagram authentication token ==", authToken)
        let url = "https://api.instagram.com/v1/users/self/?access_token=\(authToken)"
        
        Alamofire.request(url, method: .get).validate().responseJSON{ response in
            print(response.result.value!)
            switch response.result {
            case .success(let value):
                let mapper = Mapper<LoginModuleInstragram>().map(JSON: response.result.value as! [String : Any])
                
                let profilePicture = mapper?.data?.profilePicture
                print(profilePicture )
                
                
            case .failure :
                print("failure")
                
            }
        }
    }
}



struct INSTAGRAM_IDS {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID  = "e60b926d10754e399d6b30ce9a20117c"
    static let INSTAGRAM_CLIENTSERCRET = "bfa7495aa8a54baaa7b8ba6a83702374"
    static let INSTAGRAM_REDIRECT_URI = "https://www.youtube.com"
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    
}

//LoginWithInstragramByAmrit

