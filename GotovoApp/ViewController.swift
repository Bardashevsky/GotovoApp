//
//  ViewController.swift
//  GotovoApp
//
//  Created by Oleksandr Bardashevskyi on 07.04.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false


        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()

        guard let url = URL(string: "https://gotovo-staging.fly.dev/") else { return }
        webView.load(URLRequest(url: url))

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.webView.evaluateJavaScript("document.body.innerHTML") { result, error in
                guard let html = result as? String, error == nil else {
                    return
                }

                print(html)
            }
        }
    }

    private func setConstraints() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

