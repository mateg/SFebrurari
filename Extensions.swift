//
//  Extensions.swift
//  fiveSecondsGameFinal
//
//  Created by Lucas Otterling on 25/05/2017.
//  Copyright © 2017 Lucas Otterling. All rights reserved.
//

import UIKit
import Pastel

extension UILabel {
    func setSizeFont (sizeFont: CGFloat) {
        self.font =  UIFont(name: "YanoneKaffeesatz-Bold", size: sizeFont)!
        self.textColor = UIColor(red:0.96, green:0.82, blue:0.25, alpha:1.0)
        self.sizeToFit()
    }
}

extension UIColor{
    func SwedenBlue() -> UIColor{
        return UIColor(red:-0.00308827, green:0.328695, blue:0.587291, alpha:1.0)
    }
    func SwedenYellow() -> UIColor{
        return UIColor(red:0.96, green:0.82, blue:0.25, alpha:1.0)
    }
}






