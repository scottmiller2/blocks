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
    @IBOutlet weak var blocksTopBar: UILabel!
    
    
    var colorsRed: [Double] = [1.0, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.9, /*8*/ 1.0, 1.0, 0.2, 0.6, 0.5, 0.8, 0.9, 0.6, 0.0, 0.9]
    var colorsGreen: [Double] = [0.1, 0.8, 0.3, 0.6, 0.7, 0.4, 0.1, 0.3, /*8*/ 1.0, 1.0, 0.6, 1.0, 0.5, 0.3, 0.2, 0.9, 0.5, 0.8]
    var colorsBlue: [Double] = [0.2, 0.3, 0.6, 0.9, 0.4, 0.5, 0.6, 0.5, /*8*/ 1.0, 1.0, 0.9, 0.1, 0.2, 0.3, 0.9, 0.4, 0.3, 0.2]
    var colorsAlpha: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, /*8*/ 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    var orderArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
    
    var myBlocks = [UIImageView]()
    var myCircles = [UIImageView]()
    
    //counting
    var moveCounter = 0
    var scoreCounter = 0 //unness?
    var arrayCounter = 0
    var circleLocation = 0
    var matchCounter = 0
    
    //timing
    var seconds = 60
    var timer = Timer()
    
    //movement variables
    var objectDragging = 0
    var isDragging = false
    
    //match checking
    var pos1 = CGPoint (x: 0.0, y: 0.0)
    var pos2 = CGPoint (x: 0.0, y: 0.0)
    
    var xMatchTag = 0
    var yMatchTag = 0
    
    func setupGame()  {
        timerLabel.isHidden = false
        counterLabel.isHidden = false
        blocksTopBar.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    }
    
    //Step through circle array and match tint colors to match tags

    func setTags() {
        var tagCount = 0
        for x in myBlocks {
            x.tag = tagCount
            tagCount += 1
        }
    }

    func checkMatch(){
        
        for _ in myBlocks {
        if (100 / 2 > sqrt((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y))) {
            
            print("match made in checkMatch")
            myBlocks[objectDragging].isHidden = true
            myCircles[circleLocation].tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }

    }
    
    override func viewDidLoad() {
        //Shuffle the array
        var shuffledArray: [Int] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: orderArray) as! [Int]

        
        //Reorder the shuffled array so the two white circles are in index 8 and 9
        for a in 0...17 {
            if shuffledArray[a] == 8 {
            let element = shuffledArray[8]
                shuffledArray[a] = element
                shuffledArray[8] = 8
            }
            else if shuffledArray[a] == 9 {
                let element = shuffledArray[9]
                shuffledArray[a] = element
                shuffledArray[9] = 9
            }
        }
        
        //Label and background
        timerLabel.isHidden = true
        counterLabel.isHidden = true
        blocksTopBar.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        //Setup for block and circle building
        let initX = 93
        let initY = 10
        let padding = 10
        let imgWidth = 100
        
        //Setup for board shuffling
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
                
                //add the image to the circle array
                myCircles.append(circleImg)
                myCircles[arrayCounter].tag = arrayCounter
                
                
                
                //add the circle to the screen
                view.addSubview(circleImg)
                
                //set the layer position of the circle
                circleImg.layer.zPosition = 1;
                
                //squares
                let squareImg = UIImageView(image:#imageLiteral(resourceName: "square"))
                squareImg.tintColor = UIColor(red: CGFloat(colorsRed[arrayCounter]), green: CGFloat(colorsGreen[arrayCounter]), blue: CGFloat(colorsBlue[arrayCounter]), alpha: CGFloat(colorsAlpha[arrayCounter]))
                squareImg.center.x = CGFloat(initX + i * (imgWidth + padding))
                squareImg.center.y = CGFloat(initY + j * (imgWidth + padding))
                
                myBlocks.append(squareImg)
                    
                squareImg.isUserInteractionEnabled = true
                    
                squareImg.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:))))
                
                view.addSubview(squareImg)
                arrayCounter += 1
                squareImg.layer.zPosition = 2;
                nextPos += 1
            }
        }
        
        //Hide the two white squares built to index 8 and 9 (above the two white circles)
        myBlocks[8].isHidden = true
        myBlocks[9].isHidden = true
        
        //Call to set the tags for the circles and blocks on the screen
        setTags()

        //******* Debugging ********//
        //Print out the index and tags, as well as tintColors
        for y in 0...17{
        print("index \(y)")
        print("BLOCK tag \(myBlocks[y].tag)")
        print("block color \(myBlocks[y].tintColor)")
        print("CIRCLE tag \(myCircles[y].tag)")
        print("circle color \(myCircles[y].tintColor)")
        print("")
        }
        
        
        /* Check here for initial game load matches? */
    }
    
    //**** Handle the movements ***** //
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        
        objectDragging = (recognizer.view?.tag)!
        var counter = 0
        
        
        for x in myCircles {
            if myBlocks[objectDragging].tintColor == x.tintColor {
                circleLocation = counter
            }
            counter += 1
        }
        
        pos1 = myBlocks[objectDragging].center
        //pos2 = myCircles[myBlocks[objectDragging].tag].center
        pos2 = myCircles[circleLocation].center
        
        switch(recognizer.state) {
            
        case .ended:
            
            if ((100 / 2 > sqrt((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y)))) && myBlocks[objectDragging].tintColor == myCircles[circleLocation].tintColor {
                
                myBlocks[objectDragging].isHidden = true
                myCircles[circleLocation].tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                matchCounter += 1
                
                print("Match Count: \(matchCounter)")
                if matchCounter == 17 {
                    print("All matches made")
                }
            }
            else {
                moveCounter += 1
            }
            print("Move Counter: \(moveCounter)")

        default:
            break
        }
        
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
