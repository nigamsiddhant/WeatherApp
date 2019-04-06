//
//  CardView.swift
//  CSR
//
//  Created by Infxit-08893 on 25/01/19.
//  Copyright © 2019 infinx. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadiuss: CGFloat = 2

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColors: UIColor? = UIColor.black
    @IBInspectable var shadowOpacitys: Float = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadiuss
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiuss)

        layer.masksToBounds = false
        layer.shadowColor = shadowColors?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacitys
        layer.shadowPath = shadowPath.cgPath
    }

}


