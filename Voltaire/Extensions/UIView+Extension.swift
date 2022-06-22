//
//  UIView+Extension.swift
//  Voltaire
//
//  Created by user210230 on 6/18/22.
//

import UIKit

extension UIView {

  @IBInspectable  var cornerRadius:CGFloat{
        get {return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
