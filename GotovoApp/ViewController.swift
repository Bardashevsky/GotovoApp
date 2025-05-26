//
//  ViewController.swift
//  GotovoApp
//
//  Created by Oleksandr Bardashevskyi on 07.04.2023.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    private let testURL = "https://gotovo-staging.fly.dev/"
    private let test2URL = "https://8858-91-214-138-99.ngrok-free.app/"
    private let test3URL = "https://test.gotovo.app/"
    private let prodURL = "https://gotovo.app/"

    private let webConfiguration = WKWebViewConfiguration() => {
        $0.ignoresViewportScaleLimits = true
        $0.suppressesIncrementalRendering = true
        $0.allowsInlineMediaPlayback = true
        $0.allowsAirPlayForMediaPlayback = false
        $0.allowsPictureInPictureMediaPlayback = true
        $0.mediaTypesRequiringUserActionForPlayback = .all
    }

    private lazy var webView = WKWebView(frame: .zero, configuration: webConfiguration) => {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.navigationDelegate = self
        $0.uiDelegate = self
    }

//    private lazy var navigationStackView = UIStackView() => {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.axis = .horizontal
//        $0.alignment = .fill
//        $0.distribution = .fillEqually
//        $0.spacing = 10
//    }

//    private lazy var backButton = UIButton(frame: .zero) => {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.setImage(UIImage.setSVG(by: SVG.left.path), for: .normal)
//        $0.imageView?.contentMode = .scaleAspectFit
//        $0.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
//        $0.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//    }

//    private lazy var refreshButton = UIButton() => {
//        $0.isHidden = true
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.setImage(UIImage.setSVG(by: SVG.refresh.path), for: .normal)
//        $0.imageView?.contentMode = .scaleAspectFill
//        $0.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
//        $0.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
//    }

//    private lazy var forwardButton = UIButton() => {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.setImage(UIImage.setSVG(by: SVG.right.path), for: .normal)
//        $0.imageView?.contentMode = .scaleAspectFit
//        $0.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
//        $0.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        guard let url = URL(string: prodURL) else { return }
        webView.load(URLRequest(url: url))

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        Notifications.shared.register()
    }


    private func setupViews() {
        view.addSubview(webView)
//        view.addSubview(refreshButton)

//        [backButton, refreshButton, forwardButton].forEach { navigationStackView.addArrangedSubview($0) }

        setConstraints()
    }

    private func setConstraints() {
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: margins.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

//        NSLayoutConstraint.activate([
//            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            refreshButton.widthAnchor.constraint(equalToConstant: 64),
//            refreshButton.heightAnchor.constraint(equalToConstant: 64),
//        ])
    }

    // MARK: - Actions -

//    @objc private func backAction() {
//        webView.goBack()
//    }
//
//    @objc private func refreshAction() {
//        refreshButton.isUserInteractionEnabled = false
//        refreshButton.rotate()
//        webView.reload()
//    }
//
//    @objc private func forwardAction() {
//        webView.goForward()
//    }

    @objc private func appDidBecomeActive() {
//        webView.reload()
    }
}

extension ViewController: WKNavigationDelegate {
    //    func webView(_: WKWebView, didFinish _: WKNavigation!) {
    //        refreshButton.layer.removeAllAnimations()
    //        refreshButton.isUserInteractionEnabled = true
    //        refreshButton.isHidden = true
    //    }
    //
    //    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
    //        refreshButton.layer.removeAllAnimations()
    //        refreshButton.isUserInteractionEnabled = true
    //        refreshButton.isHidden = false
    //    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let token: String? = Notifications.shared.fcmToken
        if let token {
            let apiKey = "650218ff188b5b0375ba"
            webView.evaluateJavaScript("receiveDeviceToken('\(token)', '\(apiKey)')") { result, error in
                print("\(String(describing: result)) error = \(String(describing: error))")
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        let urlString = url.absoluteString

        if url.scheme == "tel" ||
            url.scheme == "geo" ||
            url.scheme == "comgooglemaps" ||
            url.scheme == "waze" ||
            urlString.contains("instagram") ||
            urlString.contains("google.com/maps") ||
            urlString.contains("facebook") ||
            urlString.contains("monobank")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }

        decisionHandler(.allow)
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith _: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures _: WKWindowFeatures) -> WKWebView? {
        if navigationAction.request.url?.host?.contains("telegram") == true {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
