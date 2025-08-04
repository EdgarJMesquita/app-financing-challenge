//
//  AFTopLeftRightBorder.swift
//  AppFinances
//
//  Created by Edgar on 04/08/25.
//

import UIKit

class AFBottomLeftRightBorder: UIView {
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
            
            pth.addLine(to: bounds.bottomLeft)
            
            // start at bottom-left corner
            pth.move(to: bounds.topLeft)
            // rounded top-left corner
            pth.addArc(tangent1End: bounds.bottomLeft, tangent2End: bounds.bottomRight, radius: radius)
            // rounded top-right corner
            pth.addArc(tangent1End: bounds.bottomRight, tangent2End: bounds.topRight, radius: radius)
            // line to bottom-right corner
            
            pth.addLine(to: bounds.topRight)
            
            shapeLayer.path = pth
            
            // round top corners of view (self)
            shapeLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            shapeLayer.cornerRadius = radius
        }
}
