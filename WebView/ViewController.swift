//
//  ViewController.swift
//  WebView
//
//  Created by Tommy Gaessler on 11/15/22.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var url: UITextField!
    
    @IBOutlet weak var navigationBarButton: UIBarButtonItem!
    
    let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        url.delegate = self
        navigationBarButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func openSafariView() {
        
        if(verifyUrl(urlString: url.text!)) {
            let vc = SFSafariViewController(url: URL(string: url.text!)!)
            
            present(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid URL", message: "Please enter a valid URL starting with https://", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openWebView() {
        
        if(verifyUrl(urlString: url.text!)) {
            view.addSubview(webView)

            guard let url = URL(string: url.text!) else {
                return
            }
            
            let navbarHeight = navigationBar.bounds.height + 1
            
            print(navbarHeight)
            print(view.safeAreaInsets.top)
            print(view.safeAreaLayoutGuide.layoutFrame.size.height)
            
            // webView.frame = view.safeAreaLayoutGuide.layoutFrame
            
            webView.frame = CGRect(x: 0, y:view.safeAreaInsets.top + navbarHeight, width: view.frame.width, height : view.safeAreaLayoutGuide.layoutFrame.size.height - navbarHeight)
            
            webView.load(URLRequest(url: url))
            navigationBarButton.isHidden = false
        } else {
            let alert = UIAlertController(title: "Invalid URL", message: "Please enter a valid URL starting with https://", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeWebView() {
        webView.removeFromSuperview()
        navigationBarButton.isHidden = true
    }
}

