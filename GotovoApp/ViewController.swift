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
    private let prodURL = "https://gotovo.app"

    private let webView =  WKWebView() => {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var navigationStackView = UIStackView() => {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 10
    }

    private lazy var backButton = UIButton(frame: .zero) => {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "arrowshape.left"), for: .normal)
        $0.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }

    private lazy var refreshButton = UIButton() => {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
    }

    private lazy var forwardButton = UIButton() => {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        $0.addTarget(self, action: #selector(forwardAction), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        guard let url = URL(string: testURL) else { return }
        self.webView.load(URLRequest(url: url))
    }

    private func setupViews() {
        view.addSubview(webView)
        view.addSubview(navigationStackView)

        [backButton, refreshButton, forwardButton].forEach { navigationStackView.addArrangedSubview($0) }

        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: navigationStackView.topAnchor)
        ])

        NSLayoutConstraint.activate([
            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationStackView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }

    //MARK: - Actions -
    @objc private func backAction() {
        webView.goBack()
    }

    @objc private func refreshAction() {
        webView.reload()
    }

    @objc private func forwardAction() {
        webView.goForward()
    }
}

