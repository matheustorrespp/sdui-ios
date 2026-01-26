//
//  UIView+Extensions.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

extension UIView {
    static func removeAnimations(didBegingCompletion: (() -> Void)?, didFinishCompletion: (() -> Void)? = nil) {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            UIView.setAnimationsEnabled(true)
            didFinishCompletion?()
        }
        didBegingCompletion?()
        CATransaction.commit()
    }
}
