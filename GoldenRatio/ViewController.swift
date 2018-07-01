//
//  ViewController.swift
//  GoldenRatio
//
//  Created by Sean and Ezra Evans on 2018/06/03.
//  Copyright © 2018 Sapphire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var seedSizeX       = 8.0
    var incr            = 0.01
    var isDrawing       = true
    var isLandScape     = true
    var maxRadius       = 0.0
    var turnFrac        = 0.5

    var centre          : CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        isLandScape = UIDevice.current.orientation.isLandscape
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        initialise()
        drawSeeds()
        btnPlus.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.continuousDraw(_:))))
    }

    @IBOutlet weak var mainCircle   : CircleView!
    @IBOutlet weak var seedSize     : UITextField!
    @IBOutlet weak var increment    : UITextField!
    @IBOutlet weak var currentFraction: UILabel!
    @IBOutlet weak var turnFraction : UITextField!
    @IBOutlet weak var btnPhi       : UIButton!
    @IBOutlet weak var btnRoot2     : UIButton!
    @IBOutlet weak var btnPi        : UIButton!
    @IBOutlet weak var btnPlus      : UIButton!
    @IBOutlet weak var btnMinus     : UIButton!
    
    @IBAction func continuous(_ sender: UIButton) {
        clearDrawing()
        getSettings()
        switch sender.titleLabel?.text {
        case "𝚽" :
            turnFrac = (1.0 + Double.squareRoot(5.0)())/2.0
        case "√2" :
            turnFrac = Double.squareRoot(2.0)()
        case "𝛑" :
            turnFrac = Double.pi
        case "+" :
            turnFrac = turnFrac + incr
//            if turnFrac > 1.0 {
//                turnFrac = 0.1
//            }
        case "−" :
            turnFrac = turnFrac - incr
            if turnFrac < 0.0 {
                turnFrac = 0.9
            }
        default : break
        }
        turnFraction.text = String(turnFrac)
        drawSeeds()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isLandScape != UIDevice.current.orientation.isLandscape {
            mainCircle.setNeedsDisplay()
            clearDrawing()
            initialise()
            drawSeeds()
        }
    }
    
    private func initialise() {
        maxRadius   = mainCircle.radius //  Double(mainCircle.bounds.size.height) / 2
        print("Origin \(mainCircle.origin)")
        print("Center \(mainCircle.center)")
        centre = CGPoint(x: mainCircle.center.x , y: mainCircle.center.y )
        print("Centre \(centre)")
        getSettings()
    }
    
    private func clearDrawing() {
        for view in self.view.subviews {
            if view.tag != 1 {
                view.removeFromSuperview()
            }
        }
        self.view.setNeedsDisplay()
    }
    
    private func getSettings() {
        incr        = Double(self.increment.text ?? "0.1")!
        turnFrac    = Double(self.turnFraction.text ?? "0.1")!
        seedSizeX   = Double(seedSize.text ?? "5")!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        getSettings()
    }
    
    private func drawSeeds() {
        let endFraction    = 100.0
        let startRadius    = seedSizeX + 5.0
        var currentDegrees = 0.0
        var currentRadians = 0.0
        var seedCount      = 0
        var currentFraction = 0.0
        var currentRadius   = startRadius //- seedSizeX
        // Draw the Centre adjusting for size of the centre view (w 20: h 20)
        drawCentre(at: CGPoint(x: centre.x - 10 , y: centre.y - 10 ))
        // Draw the seeds
        for _ in stride(from: 0.0, to: endFraction, by: turnFrac) {
            seedCount += 1
            if seedCount > 1000 {
                CommonCode.showAlert(title: "Too many seeds!", message: "")
            } else {
                if currentFraction + turnFrac > 1.0 {
                    //print("Next Turn \(currentDegrees) radius \(currentRadius)")
                    currentFraction = currentFraction - 1
                    currentRadius   = currentRadius + (1.1 * seedSizeX)
                } else {
                    currentFraction = currentFraction + turnFrac
                    
                    if currentRadius > (maxRadius + startRadius - mainCircle.margin - seedSizeX ) {
                        //print("Radius \(maxRadius) margin \(mainCircle.margin)")
                        break
                    } else {
                        currentDegrees = 360 * currentFraction
                        currentRadians = currentDegrees * Double.pi / 180
                        // get point on circumference
                        let seedX = (cos(currentRadians) * currentRadius) + Double(centre.x) - Double(seedSizeX/2)
                        let seedY = (sin(currentRadians) * currentRadius) + Double(centre.y) - Double(seedSizeX/2)
                        let seedPoint = CGPoint(x: seedX, y: seedY)
                        // print("Degrees \(currentDegrees) Point \(seedPoint)")
                        drawSeed(radius: currentRadius, at: seedPoint)
                    }
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
    
    @objc func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func continuousDraw(_ gestureRecognizer: UITapGestureRecognizer) {
        getSettings()
        for _ in stride(from: turnFrac, to: 1.0, by: incr) {
            UIView.animate(withDuration: 0.2, delay: 0.2, options:.allowAnimatedContent, animations: {
                self.clearDrawing()
                CommonCode.showAlert(title: "Next!", message: "")
                self.drawSeeds()
            }, completion: nil)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//                self.drawSeeds()
//            })
        }
    }

}

extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        print("Done")
        self.resignFirstResponder()
    }
}
