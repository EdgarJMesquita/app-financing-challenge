//
//  AFTopLeftRightBorder.swift
//  AppFinances
//
//  Created by Edgar on 04/08/25.
//

import UIKit

class AFTopLeftRightBorder: UIView {
    lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer
        override class var layerClass: AnyClass {
            return CAShapeLayer.self
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        func commonInit() {
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.afGray300.cgColor
            shapeLayer.lineWidth = 1
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let radius: CGFloat = 12.0
            
            let pth = CGMutablePath()
            
            // start at bottom-left corner
            pth.move(to: bounds.bottomLeft)
            // rounded top-left corner
            pth.addArc(tangent1End: bounds.topLeft, tangent2End: bounds.topRight, radius: radius)
            // rounded top-right corner
            pth.addArc(tangent1End: bounds.topRight, tangent2End: bounds.bottomRight, radius: radius)
            // line to bottom-right corner
            pth.addLine(to: bounds.bottomRight)
          
            shapeLayer.path = pth
            
            // round top corners of view (self)
            shapeLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            shapeLayer.cornerRadius = radius
        }
}
