//
//  UIView + Extension.swift
//  GotovoApp
//
//  Created by Oleksandr Bardashevskyi on 17.05.2023.
//

import UIKit

extension UIView {
    func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: -Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
}
