//
//  ViewController.swift
//  blocks1
//
//  Created on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    //@IBOutlet weak var blocksMenu: UILabel!
    @IBOutlet weak var blocksTopBar: UILabel!
    
    
    var colorsRed: [Double] = [0.6, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 1.0, /*8*/ 1.0, 1.0, 0.2, 0.6, 0.5, 0.8, 0.9, 1.0, 0.0, 0.9]
    var colorsGreen: [Double] = [0.9, 0.8, 0.3, 0.6, 0.7, 0.4, 0.1, 0.3, /*8*/ 1.0, 1.0, 0.6, 1.0, 0.5, 0.3, 0.2, 0.1, 0.5, 0.8]
    var colorsBlue: [Double] = [0.4, 0.3, 0.6, 0.9, 0.4, 0.5, 0.6, 0.5, /*8*/ 1.0, 1.0, 0.9, 0.1, 0.2, 0.3, 0.9, 0.2, 0.3, 0.2]
    var colorsAlpha: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, /*8*/ 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    var orderArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
    
    
    var scoreCounter = 0
    var arrayCounter = 0
    
    var indexCount = 0

    var seconds = 60
    var timer = Timer()
    var blockColor = 0.0
    
    var isDragging = false
    
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
        
        var shuffledArray: [Int] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: orderArray) as! [Int]
        print(shuffledArray)
        
        //reorder the shuffled array so the two white circles are in index 8 and 9
        for a in 0...17 {
            print("For loop index: #\(a)")
            if shuffledArray[a] == 9 && shuffledArray[8] == 8{
                let element = shuffledArray.remove(at: a)
                shuffledArray.insert(element, at: 9)
                print(shuffledArray)
            }
            if shuffledArray[a] == 9 && shuffledArray[8] != 8{
                let element = shuffledArray.remove(at: a)
                shuffledArray.insert(element, at: 8)
                print(shuffledArray)
            }
            if shuffledArray[a] == 8 && shuffledArray[8] != 8{
                let element = shuffledArray.remove(at: a)
                shuffledArray.insert(element, at: 8)
                print(shuffledArray)
            }
        }
        
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
        
        //setup for board shuffling
        var nextPos = 0
        
        //begin creation of game pieces
        for i in 0...2 {
            for j in 1...6 {
                
                let randArrayVar = shuffledArray[nextPos]

                
                //circles
                    let circleImg = UIImageView(image:#imageLiteral(resourceName: "circle"))
                circleImg.tintColor = UIColor(red: CGFloat(colorsRed[randArrayVar]), green: CGFloat(colorsGreen[randArrayVar]), blue: CGFloat(colorsBlue[randArrayVar]), alpha: 1.0)
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
                print("nextPos: #\(nextPos)")
                print("indexCount: #\(indexCount)")
                print("randArrayVar: #\(randArrayVar)")
                print(squareImg.center)
                nextPos += 1
                indexCount += 1
                //}
            }
            
        }
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.view)
            print(position.x)
            print(position.y)
        }
    }*/
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
    
        //if dragging = true and objectDragging == recognizer.view
        //  allow it to do logic below
        //  otherwise exit.. this will let us only drag one object at a time
        
        if recognizer.state == UIGestureRecognizerState.began {
            isDragging = true
            
            let objectDragging = self.view //wrong
            
            print("bg color of block \(objectDragging?.backgroundColor)")
            
            //if isDragging = true && objectMoving == recognizer.view {
                
            //}
            
            
            //initial position
            //which object - objectDragging
        }
        else if recognizer.state == UIGestureRecognizerState.ended {
            isDragging = false
        }
        else {
            //dragging
            //initPosition converted to nearest grid position
            //check if view.center is "allowed"
            //no further than 1 unit away up/down/side
            //Bound cgpoint to no further than 1 unit away
            //var cgp:CGPoint = CGPoint(x:view.center.x + translation.x,
            //  y:view.center.y + translation.y)
            
            //if distance(cgp, initPoint) > padding + imgWidth:
            //(cgp - initPoint).normalize * (padding+imgWidth)
            //normalize = (x,y)/length of (x,y)
            
            //plain english. if distance between current point and initial point is greater
            //than one grid unit, take the direction of the vector, shorten it to a unit vector,
            //use the unit vector to calculate one grid unit in that direction
            
            if let view = recognizer.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            //if object matches object in recognizer
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
