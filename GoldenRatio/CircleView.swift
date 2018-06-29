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
//    var _radius = 0.0
    
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
//        var path = UIBezierPath()
//        var path = UIBezierPath(ovalIn: CGRect(x: self.frame.size.width/2 - self.frame.size.height/2,
//                                                y: 0.0,
//                                                width: self.frame.size.height,
//                                                height: self.frame.size.height))
        var path = UIBezierPath(ovalIn: CGRect(x: self.bounds.size.width/2 - self.bounds.size.height/2,
                                               y: 0.0,
                                               width: self.bounds.size.height,
                                               height: self.bounds.size.height))
//        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
//        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
//        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + _margin))
//        context.closePath()
//
        context.setFillColor(_color.cgColor)
        UIColor.black.setStroke()
        path.lineWidth = 1.0
        path.fill()
        path.stroke()
        context.fillPath()
    }
}
