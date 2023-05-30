//
//  UIImage+Extension.swift
//  GotovoApp
//
//  Created by Oleksandr Bardashevskyi on 30.05.2023.
//

import SVGKit
import UIKit

protocol ImageItemProtocol {
    var path: String { get }
}

enum SVG: String, ImageItemProtocol {
    var path: String {
        // will be using on future
        let prefix = "svg/" //Base/"
        return "\(prefix)\(self.rawValue)"
    }

    case `left` = "left.svg"
    case `refresh` = "refresh.svg"
    case `right` = "right.svg"
}

extension UIImage {
    static func setSVG(by path: String) -> UIImage? {
        guard Bundle.main.path(forResource: path, ofType: nil) != nil else {
            return nil
        }

        let svgImage: SVGKImage = SVGKImage(named: path)
        //required. always call "hasSize"
        svgImage.hasSize()

        return svgImage.uiImage
    }
}
