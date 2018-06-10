//
//  ShapeView.swift
//  GoldenRatio
//
//  Created by Sean and Ezra Evans on 2018/06/03.
//  Copyright © 2018 Sapphire. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    var _color: UIColor! = UIColor.blue
    var _margin: CGFloat! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
//        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
//        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
//        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + _margin))
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: rect.maxX - _margin, y: rect.maxY - _margin))
        context.move(to: CGPoint(x: rect.minX + _margin, y: rect.maxY - _margin))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY + _margin))
        context.closePath()
        
        context.setFillColor(_color.cgColor)
//        UIColor.black.setStroke()
        context.fillPath()
    }

}
