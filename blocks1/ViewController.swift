//
//  ViewController.swift
//  blocks1
//
//  Created on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    //@IBOutlet weak var blocksMenu: UILabel!
    @IBOutlet weak var blocksTopBar: UILabel!
    
    
    var colorsRed: [Double] = [0.6, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0, /*8*/ 1.0, 1.0, 0.2, 0.6, 0.7, 0.8, 0.9, 1.0, 0.0, 0.9]
    var colorsGreen: [Double] = [0.9, 0.8, 0.3, 0.6, 0.5, 0.4, 0.2, 0.1, /*8*/ 1.0, 1.0, 0.6, 1.0, 0.4, 0.3, 0.2, 0.1, 0.5, 0.8]
    var colorsBlue: [Double] = [0.4, 0.3, 0.6, 0.9, 0.4, 0.5, 0.6, 0.5, /*8*/ 1.0, 1.0, 0.9, 0.1, 0.2, 0.3, 0.4, 0.2, 0.3, 0.2]
    var colorsAlpha: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, /*8*/ 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    var scoreCounter = 0
    var arrayCounter = 0
    
    var indexCount = 0
    let diceRoll = 0

    var seconds = 60
    var timer = Timer()
    var blockColor = 0.0
    
    @IBAction func menuPlayButtonPressed(_ sender: Any) {
        setupGame()
        timerLabel.isHidden = false
        counterLabel.isHidden = false
        blocksTopBar.isHidden = false
    }

    func setupGame()  {
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        
        //UI Mask View (prevent touching during menu state
        
        /*UI Menu
        menuView.layer.zPosition = 4
        self.menuView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.7
        menuView.layer.shadowOffset = CGSize(width: 25, height: 20)
        menuView.layer.shadowRadius = 15*/
        
        //label and background
        timerLabel.isHidden = true
        counterLabel.isHidden = true
        blocksTopBar.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //setup for block and circle building
        let initX = 93
        let initY = 10
        let padding = 10
        let imgWidth = 100
        
        for i in 0...2 {
            for j in 1...6 {
                
                if indexCount == 8 || indexCount == 9 {
                    let circleImg = UIImageView(image:#imageLiteral(resourceName: "circle"))
                    circleImg.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    circleImg.center.x = CGFloat(initX + i * (imgWidth + padding))
                    circleImg.center.y = CGFloat(initY + j * (imgWidth + padding))
                    
                    view.addSubview(circleImg)
                    circleImg.layer.zPosition = 1;
                }
                else {
                //circles
                let circleImg = UIImageView(image:#imageLiteral(resourceName: "circle"))
                circleImg.tintColor = UIColor(red: CGFloat(colorsRed[arrayCounter]), green: CGFloat(colorsGreen[arrayCounter]), blue: CGFloat(colorsBlue[arrayCounter]), alpha: 1.0)
                circleImg.center.x = CGFloat(initX + i * (imgWidth + padding))
                circleImg.center.y = CGFloat(initY + j * (imgWidth + padding))
                
                view.addSubview(circleImg)
                circleImg.layer.zPosition = 1;
                
                //squares
                let squareImg = UIImageView(image:#imageLiteral(resourceName: "square"))
                squareImg.tintColor = UIColor(red: CGFloat(colorsRed[arrayCounter]), green: CGFloat(colorsGreen[arrayCounter]), blue: CGFloat(colorsBlue[arrayCounter]), alpha: CGFloat(colorsAlpha[arrayCounter]))
                squareImg.center.x = CGFloat(initX + i * (imgWidth + padding))
                squareImg.center.y = CGFloat(initY + j * (imgWidth + padding))
                arrayCounter += 1
                    
                squareImg.isUserInteractionEnabled = true
                    
                squareImg.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:))))
                
                view.addSubview(squareImg)
                squareImg.layer.zPosition = 2;
                }
            }
            indexCount += 1
            print("the indexCount is #\(indexCount)")
        }
    }
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
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
