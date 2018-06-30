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
    var isLandScape     = true
    var maxRadius       = 0.0
    var centre : CGPoint!
//    var offSetx         = 0.0
//    var offSety         = 0.0
    var turnFrac        = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        isLandScape = UIDevice.current.orientation.isLandscape
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        initialise()
        drawSeeds()
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isLandScape != UIDevice.current.orientation.isLandscape {
            initialise()
        }
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
        maxRadius   = mainCircle.radius //  Double(mainCircle.bounds.size.height) / 2
        print("Radius \(maxRadius) margin \(mainCircle.margin)")
//        print("Centre x \(mainCircle.bounds.size.width/2 + mainCircle.bounds.origin.x) y \(mainCircle.bounds.size.height/2 + mainCircle.bounds.origin.y)")
        print("Origin 2 \(mainCircle.origin)")
        print("Center \(mainCircle.center)")
        //print("Margin \(mainCircle.margin)")
        centre = CGPoint(x: mainCircle.center.x - mainCircle.origin.x, y: mainCircle.center.y - mainCircle.origin.y)
        print("Centre \(centre)")
        getSettings()
        if isLandScape != UIDevice.current.orientation.isLandscape {
            mainCircle.setNeedsDisplay()
            drawSeeds()
        }
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
        let startRadius    = seedSizeX + 5.0
        var currentDegrees = 0.0
        var currentRadians = 0.0
        
        var currentFraction = 0.0
        var currentRadius   = startRadius //- seedSizeX
        // Draw the Centre
        drawCentre(at: CGPoint(x: mainCircle.center.x , y: mainCircle.center.y - CGFloat(mainCircle.margin/2) ))
//        drawCentre(at: CGPoint(x: mainCircle.center.x + CGFloat(mainCircle.margin/2), y: mainCircle.center.y - CGFloat(mainCircle.margin/2) ))
//        drawCentre(at: CGPoint(x: mainCircle.center.x + (mainCircle.origin.x/2), y: mainCircle.center.y - (mainCircle.origin.y/2) ))
        // Draw the seeds
        for _ in stride(from: 0.0, to: endFraction, by: turnFrac) {
            if currentFraction + turnFrac > 1.0 {
                //print("Next Turn \(currentDegrees) radius \(currentRadius)")
                currentFraction = currentFraction - 1
                currentRadius   = currentRadius + (1.1 * seedSizeX)
            } else {
                currentFraction = currentFraction + turnFrac
                
                if currentRadius > (maxRadius + startRadius - mainCircle.margin ) {
                    //print("Radius \(maxRadius) margin \(mainCircle.margin)")
                    break
                } else {
                    currentDegrees = 360 * currentFraction
                    currentRadians = currentDegrees * Double.pi / 180
                    // get point on circumference
                    let seedX = (cos(currentRadians) * currentRadius) + Double(centre.x) + Double(mainCircle.origin.x)
                    let seedY = (sin(currentRadians) * currentRadius) + Double(centre.y) + Double(mainCircle.origin.y)
                    let seedPoint = CGPoint(x: seedX, y: seedY)
                    // print("Degrees \(currentDegrees) Point \(seedPoint)")
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
        self.view.addSubview(seedView)
        mainCircle.setNeedsDisplay()
    }
    
    private func drawCentre(at: CGPoint) {
        let seedViewRect = CGRect(origin: at, size: CGSize(width: 20, height: 20))
        let seedView = ShapeView(frame: seedViewRect)
        self.view.addSubview(seedView)
        mainCircle.setNeedsDisplay()
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
