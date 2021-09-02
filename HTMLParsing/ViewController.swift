//
//  ViewController.swift
//  HTMLParsing
//
//  Created by daanff on 2021-09-01.
//

import UIKit
import WebKit
import HTMLKit

class ViewController: UIViewController {
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webView
    }()
    
    let urlString = "https://www.google.com.hk/search?q=car&sxsrf=AOaemvKV1XfeIs-S3vEOs1et1wl7uBuSXg:1630546594574&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiCnry0k9_yAhUbFVkFHXsdBI4Q_AUoAXoECAEQAw&biw=1920&bih=967"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(webView)
//        webView.frame = view.bounds
        webView.navigationDelegate = self
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //parsing
        parseImages()
    }
    
    func parseImages(){
        //<img scr="..." />
        webView.evaluateJavaScript("document.body.innerHTML") {result , error in
            guard let html = result as? String, error == nil else {
                return
            }
            let document = HTMLDocument(string: html)
            let images: [String] = document.querySelectorAll("img").compactMap({element in
                guard let src = element.attributes["src"] as? String else {
                    return nil
                }
                return src
            })
            print("Found \(images.count) images")
//            print(images)
        }
    }
}

