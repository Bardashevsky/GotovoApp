//
//  NBInit.swift
//  GotovoApp
//
//  Created by Oleksandr Bardashevskyi on 18.04.2023.
//

import Foundation

infix operator =>

public func =><T: AnyObject>(left: T, f: (T) -> Void) -> T {
    f(left)
    return left
}
