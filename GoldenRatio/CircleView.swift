//
//  CircleView.swift
//  GoldenRatio
//
//  Created by Sean Evans on 2018/06/03.
//  Copyright © 2018 Sapphire. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {

    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0
    var radius = 0.0
    var origin : CGPoint!
    
    @IBInspectable var margin: Double {
        get { return Double(_margin)}
        set { _margin = CGFloat(newValue)}
    }
    
    @IBInspectable var fillColor: UIColor? {
        get { return _color }
        set{ _color = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        let squareX = min(self.frame.size.height, self.frame.size.width) - _margin
        radius = Double(squareX) / 2.0
//        let offset = (self.frame.size.width - squareX) / 2.0
        let offsetx = (self.frame.size.width / 2.0) - CGFloat(radius)
        let offsety = (self.frame.size.height / 2.0) - CGFloat(radius)
//        print("Origin : \(self.bounds.origin.x) y \(self.bounds.origin.y)")
        origin = CGPoint(x: offsetx, y: offsety)
//        print("Rad : \(radius)")
//        print("Cen : \(center)")
//        print("Offsetx : \(offsetx) y \(offsety)")
        let path = UIBezierPath(ovalIn: CGRect(x: origin.x,
                                               y: origin.y,
                                               width: squareX,
                                               height: squareX))

        context.setFillColor(_color.cgColor)
        UIColor.black.setStroke()
        path.lineWidth = 1.0
        path.fill()
        path.stroke()
        context.fillPath()
    }
}
