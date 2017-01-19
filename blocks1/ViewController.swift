//
//  ViewController.swift
//  blocks1
//
//  Created on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

import UIKit

//This extension allows a number to be generated between a supplied minimum and maxiumum—in this case 0.1 and 1.0.
extension Double {
    
    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Color Arrays
    var colorsRed: [Double] = [0.3, 0.7, 0.1, 0.2, 0.9, 0.5, 0.6, 0.2, 1.0, 0.6, 0.1, 0.2, 1.0, 0.4, 0.5, 0.3, 0.4, 0.3]
    var colorsGreen: [Double] = [0.6, 0.4, 0.1, 0.2, 0.7, 0.5, 1.0, 0.2, 0.8, 0.6, 0.6, 0.4, 0.4, 0.5, 0.4, 0.3, 0.4, 0.3]
    var colorsBlue: [Double] = [0.1, 0.7, 0.5, 0.6, 0.6, 0.5, 0.1, 0.9, 0.5, 0.9, 0.4, 0.7, 0.5, 0.2, 0.3, 0.5, 0.3, 1.0]
    var scoreCounter = 0
    var arrayCounter = 0
    
    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
    
    //circle creator
    
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // build a circle
    func makeCircle()->()
    {
    
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(50), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        let diceRoll = Int(arc4random_uniform(UInt32(18)))
        print("Your random number is #\(diceRoll + 1)!")
        
        let randColor = UIColor(red: CGFloat(colorsRed[diceRoll]), green: CGFloat(colorsGreen[diceRoll]), blue: CGFloat(colorsBlue[diceRoll]), alpha: CGFloat(1.0))
        
        //change the fill color
        shapeLayer.fillColor = randColor.cgColor
        print("Your random color is #\(randColor)!")
        
        view.layer.addSublayer(shapeLayer)
    }

    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to the storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        // Use the outlet in the custom class to get a reference to the UILabel in the cell
        
        /*
        let rnd1 = Double.random(min: 0.1, max: 1.0)
        colorsRed[arrayCounter] = rnd1
        let rnd2 = Double.random(min: 0.1, max: 1.0)
        colorsGreen[arrayCounter] = rnd2
        let rnd3 = Double.random(min: 0.1, max: 1.0)
        colorsBlue[arrayCounter] = rnd3
        */

        cell.backgroundColor = UIColor(red: CGFloat(colorsRed[arrayCounter]), green: CGFloat(colorsGreen[arrayCounter]), blue: CGFloat(colorsBlue[arrayCounter]), alpha: CGFloat(1.0))
        
        makeCircle()
        
        cell.myLabel.text = self.items[indexPath.item]
        if indexPath.item == 7 || indexPath.item == 10 {
            cell.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1.0))
        }

        arrayCounter += 1
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        scoreCounter += 1
        counterLabel.text = "\(scoreCounter)"
        print("You selected cell #\(indexPath.item + 1)!")
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
        //counterLabel.isHidden = false
        
        //Print colors added in
        var redCount = 1
        var greenCount = 1
        var blueCount = 1
        for item in colorsRed {
            print("Red \(redCount)")
            redCount += 1
            print(item)
        }
        for item in colorsGreen {
            print("Green \(greenCount)")
            greenCount += 1
            print(item)
        }
        for item in colorsBlue {
            print("Blue \(blueCount)")
            blueCount += 1
            print(item)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
        counterLabel.isHidden = true
        blocksTopBar.isHidden = true
        
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
