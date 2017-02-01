//
//  ViewController.swift
//  blocks1
//
//  Created on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    //Color Arrays
    var colorsRed: [Double] = [0.6, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0, /*8*/ 0.6, 0.2, 1.0, 0.6, 0.7, 0.8, 0.9, 1.0, 0.0, 0.9]
    var colorsGreen: [Double] = [0.9, 0.8, 0.3, 0.6, 0.5, 0.4, 0.3, 1.0, /*8*/ 0.2, 0.6, 1.0, 1.0, 0.4, 0.3, 0.2, 0.1, 0.5, 0.8]
    var colorsBlue: [Double] = [0.4, 0.3, 0.6, 0.9, 0.4, 0.5, 0.6, 1.0, /*8*/ 0.8, 0.9, 1.0, 0.1, 0.2, 0.3, 0.4, 0.2, 0.3, 0.2]
    var scoreCounter = 0
    var arrayCounter = 0
    
    let reuseIdentifier = "cell"
    var items = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
    
    
    // build a circle
    var circleCount = 0
    let diceRoll = 0
    func makeCircle()
    {
    
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(49), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        let diceRoll = Int(arc4random_uniform(UInt32(18)))
        
        print("The random number for diceRoll is #\(diceRoll)")
        
        let randColor = UIColor(red: CGFloat(colorsRed[diceRoll]), green: CGFloat(colorsGreen[diceRoll]), blue: CGFloat(colorsBlue[diceRoll]), alpha: CGFloat(1.0))
        
        //change the fill color
        shapeLayer.fillColor = randColor.cgColor
        print("The circle at index #\(circleCount) is color #\(randColor)")
        
        circleCount += 1
        view.layer.addSublayer(shapeLayer)
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var blocksMenu: UILabel!
    @IBOutlet weak var blocksTopBar: UILabel!

    var seconds = 60
    var timer = Timer()
    var blockColor = 0.0
    
    @IBAction func playButtonPressed(_ sender: AnyObject) {
        menuView.isHidden = true
        helpButton.isHidden = true
        setupGame()
        timerLabel.isHidden = false
        counterLabel.isHidden = false
        blocksMenu.isHidden = true
    }
    
    func setupGame()  {
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    
        playButton.isHidden = true
        blocksTopBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
        counterLabel.isHidden = true
        blocksTopBar.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        let initX = 93
        let initY = 10
        let padding = 10
        let imgWidth = 100
        
        for i in 0...2 {
            for j in 1...6 {
                let img = UIImageView(image:#imageLiteral(resourceName: "square"))
                
                img.center.x = CGFloat(initX + i * (imgWidth + padding))
                img.center.y = CGFloat(initY + j * (imgWidth + padding))
                
                //var panRecognizer = UIPanGestureRecognizer(target:self.parent, action:"handlePan:")
                //img.gestureRecognizers = [panRecognizer]
                
                view.addSubview(img)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subtractTime() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
        
        if(seconds == 0)  {
            timer.invalidate()
        }
        else if (seconds <= 10) {
            timerLabel.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
