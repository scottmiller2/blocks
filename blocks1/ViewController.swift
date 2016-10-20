//
//  ViewController.swift
//  blocks1
//
//  Created by Scott Miller on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

    var seconds = 60 //Default timer sets to 60
    var timer = Timer()
    var blockColor = 0.0 //new 20th
    
    @IBAction func playButtonPressed(_ sender: AnyObject) {
        setupGame()
        timerLabel.isHidden = false
    }
    
    func setupGame()  {
        
        var coloredSquare = UIView()
        var seconds = 60
        
        //new 20th
        func randColor(){

            var color = 1.0
            color = Double(Int(arc4random_uniform((100) * 10) / 100))
            if (color == 0){
                randColor()
            }
            blockColor = color
            print("")
            print("Testing blockColor value: ", blockColor) //debugging to test random number
        }
        //working to here
        
        func colorAssigner(){
            var rand1: Double = 1.0
            var rand2: Double = 1.0
            var rand3: Double = 1.0
            var rand4: Double = 1.0
            
            
            for _ in 0..<1 {
                randColor()
                rand1 = blockColor
                randColor()
                rand2 = blockColor
                randColor()
                rand3 = blockColor
                randColor()
                rand4 = blockColor
                coloredSquare.backgroundColor = UIColor(red: CGFloat(rand1), green: CGFloat(rand2), blue: CGFloat(rand3), alpha: CGFloat(rand4))
                coloredSquare.frame = CGRect(x: 5, y: 120, width: 100, height: 100)
                self.view.addSubview(coloredSquare)
                print("")
                print("Testing rand1 value: ", rand1) //debugging to test random number
                print("Testing rand2 value: ", rand2)
                print("Testing rand3 value: ", rand3)
                print("Testing rand4 value: ", rand4)
            }
        }
        //end random block color
        //begin drawing
        
        colorAssigner()
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    
        
        /////Call to random color generator
        
        // set frame (position and size) of the square
        // iOS coordinate system starts at the top left of the screen
        // so this square will be at top left of screen, 50x50pt
        // CG in CGRect stands for Core Graphics
        //coloredSquare.frame = CGRect(x: 5, y: 120, width: 100, height: 100)
        
        // finally, add the square to the screen
        //self.view.addSubview(coloredSquare)
        playButton.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
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

