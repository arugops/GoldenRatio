//
//  ViewController.swift
//  GoldenRatio
//
//  Created by Sean and Ezra Evans on 2018/06/03.
//  Copyright © 2018 Sapphire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var seedSizeX       = 8.0
    var incr            = 0.01
    var isDrawing       = true
    var maxRadius       = 0.0
    var offSetx         = 0.0
    var offSety         = 0.0
    var turnFrac        = 0.68901

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialise()
        drawSeeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }

    @IBOutlet weak var mainCircle   : CircleView!
    @IBOutlet weak var seedSize     : UITextField!
    @IBOutlet weak var increment    : UITextField!
    @IBOutlet weak var currentFraction: UILabel!
    @IBOutlet weak var turnFraction : UITextField!
    
    @IBAction func drawFlower(_ sender: Any) {
        getSettings()
        incrementAndDraw(forwards: true)
    }
    
    @IBAction func continuous(_ sender: UIButton) {
        getSettings()
        incrementAndDraw(forwards: false)
    }
    
    private func incrementAndDraw(forwards : Bool) {
        clearDrawing()
        if forwards {
            turnFrac = turnFrac + incr
            if turnFrac > 1.0 {
                turnFrac = 0.1
            }
        } else {
            turnFrac = turnFrac - incr
            if turnFrac < 0.0 {
                turnFrac = 0.9
            }
        }
        turnFraction.text = String(turnFrac)
        drawSeeds()
    }
    
    private func initialise() {
        maxRadius   =  Double(mainCircle.frame.size.height)
        //maxRadius   = Double(self.view.frame.maxX/2)
        offSetx     = Double(self.view.center.x) - self.seedSizeX/2
        offSety     = Double(self.view.center.y) - self.seedSizeX/2
        getSettings()
    }
    
    private func clearDrawing() {
        for view in self.view.subviews {
            if view.tag != 1 {
                view.removeFromSuperview()
            }
        }
        self.view.setNeedsDisplay()
        turnFrac   = Double(self.turnFraction.text ?? "0.1")!
    }
    
    private func getSettings() {
        incr        = Double(self.increment.text ?? "0.1")!
        turnFrac    = Double(self.turnFraction.text ?? "0.1")!
        seedSizeX   = Double(seedSize.text ?? "5")!
    }
    
    private func drawSeeds() {
        let endFraction    = 100.0
        let startRadius    = 30.0
        var currentDegrees = 0.0
        var currentRadians = 0.0
        
        var currentFraction = 0.0
        var currentRadius   = startRadius //- seedSizeX
        // Draw the seeds
        for _ in stride(from: 0.0, to: endFraction, by: turnFrac) {
            if currentFraction + turnFrac > 1.0 {
                //print("Next Turn \(currentDegrees) radius \(currentRadius)")
                currentFraction = currentFraction - 1
                currentRadius   = currentRadius + (1.2 * seedSizeX)
            } else {
                currentFraction = currentFraction + turnFrac
                
                if currentRadius > maxRadius {
                    break
                } else {
                    currentDegrees = 360 * currentFraction
                    currentRadians = currentDegrees * Double.pi / 180
                    // get point on circumference
                    let seedX = (cos(currentRadians) * currentRadius) + offSetx
                    let seedY = (sin(currentRadians) * currentRadius) + offSety
                    let seedPoint = CGPoint(x: seedX, y: seedY)
                    //print("Degrees \(currentDegrees) Point \(seedPoint)")
                    drawSeed(radius: currentRadius, at: seedPoint)
                }
            }
        }
        let trueFraction = rationalApproximation(of: turnFrac, withPrecision: 1.0E-10)
        self.currentFraction.text = "Approx Fraction : \(trueFraction.num)/\(trueFraction.den)"
    }
    
    private func drawSeed(radius: Double, at: CGPoint) {
        let seedViewRect = CGRect(origin: at, size: CGSize(width: seedSizeX, height: seedSizeX))
        let seedView = ShapeView(frame: seedViewRect)
//        let bgColor = UIColor(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
//        UIView.animate(withDuration: 5, delay: 1.0, options:.allowAnimatedContent, animations: {
        //mainCircle.addSubview(seedView)
        self.view.addSubview(seedView)
        mainCircle.setNeedsDisplay()
 //       }, completion: nil)
//        UIView.animate(withDuration: 5.0, delay: 0.5, options:.allowAnimatedContent, animations: {
//            seedView.alpha = 0
////            seedView.setNeedsDisplay()
//        }, completion: nil)
    }
    
    
    // courtesy of https://stackoverflow.com/questions/35895154/decimal-to-fraction-conversion-in-swift
    typealias Rational = (num : Int, den : Int)
    
    func rationalApproximation(of x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
}

/*
 @IBAction func continuous(_ sender: UIButton) {
 isDrawing = !isDrawing
 //        if !isDrawing {
 getSettings()
 for _ in 0...100 {
 //                UIView.animate(withDuration: 0.2, delay: 0.2, options:.allowAnimatedContent, animations: {
 //                    self.incrementAndDraw()
 //                }, completion: nil)
 
 //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
 self.incrementAndDraw()
 //                })
 }
 //        }
 }
*/
