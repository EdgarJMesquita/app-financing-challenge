//
//  UIView+Ext.swift
//  App de Finanças
//
//  Created by Edgar on 21/06/25.
//

import UIKit

extension UIView {
    func afApplyGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.afGradientDark.cgColor,
            UIColor.afGradientLight.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    func afAddTopLeftRightBorder(radius: CGFloat = 12.0, color: UIColor = .afGray300, lineWidth: CGFloat = 1.0) {
  
            layer.sublayers?.removeAll(where: { $0.name == "SideBorderLayer" })

            let shapeLayer = CAShapeLayer()
            shapeLayer.name = "SideBorderLayer"
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = lineWidth
       
        
            shapeLayer.lineCap = .butt

            let inset = shapeLayer.lineWidth / 2
            let insetBounds = bounds.insetBy(dx: inset, dy: inset)

            let path = CGMutablePath()
            path.move(to: insetBounds.bottomLeft)
            path.addArc(tangent1End: insetBounds.topLeft, tangent2End: insetBounds.topRight, radius: radius)
            path.addArc(tangent1End: insetBounds.topRight, tangent2End: insetBounds.bottomRight, radius: radius)

            path.addLine(to: insetBounds.bottomRight)
            
            shapeLayer.path = path

            layer.addSublayer(shapeLayer)

        }
    
    func afAddBottomLeftRightBorder(radius: CGFloat = 12.0, color: UIColor = .afGray300, lineWidth: CGFloat = 1.0) {

        layer.sublayers?.removeAll(where: { $0.name == "SideBorderLayer" })

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "SideBorderLayer"
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
   
    
        shapeLayer.lineCap = .butt

        let inset = shapeLayer.lineWidth / 2
        let insetBounds = bounds.insetBy(dx: inset, dy: inset)

        let path = CGMutablePath()
        path.move(to: insetBounds.topLeft)
        path.addArc(tangent1End: insetBounds.bottomLeft, tangent2End: insetBounds.bottomRight, radius: radius)
        path.addArc(tangent1End: insetBounds.bottomRight, tangent2End: insetBounds.topRight, radius: radius)
        path.addLine(to: insetBounds.topRight)

        
        shapeLayer.path = path

        layer.addSublayer(shapeLayer)

    }
    
    func afAddLeftRightBorder(radius: CGFloat = 12.0, color: UIColor = .afGray300, lineWidth: CGFloat = 1.0) {

        layer.sublayers?.removeAll(where: { $0.name == "SideBorderLayer" })

        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "SideBorderLayer"
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
   
    
        shapeLayer.lineCap = .butt

        let inset = shapeLayer.lineWidth / 2
        let insetBounds = bounds.insetBy(dx: inset, dy: inset)

        let path = CGMutablePath()
        // Left border line
        path.move(to: CGPoint(x: insetBounds.minX, y: insetBounds.minY))
        path.addLine(to: CGPoint(x: insetBounds.minX, y: insetBounds.maxY))

        // Right border line
        path.move(to: CGPoint(x: insetBounds.maxX, y: insetBounds.minY))
        path.addLine(to: CGPoint(x: insetBounds.maxX, y: insetBounds.maxY))

        shapeLayer.path = path

        layer.addSublayer(shapeLayer)

    }
    
}
