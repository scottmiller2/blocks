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
    
    @IBAction func playButtonPressed(_ sender: AnyObject) {
        setupGame()
        timerLabel.isHidden = false
    }

    func setupGame()  {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
        
        // Create and add a colored square
        let coloredSquare = UIView()
        
        // set background color to blue
        coloredSquare.backgroundColor = UIColor.blue
        
        // set frame (position and size) of the square
        // iOS coordinate system starts at the top left of the screen
        // so this square will be at top left of screen, 50x50pt
        // CG in CGRect stands for Core Graphics
        coloredSquare.frame = CGRect(x: 5, y: 120, width: 100, height: 100)
        
        // finally, add the square to the screen
        self.view.addSubview(coloredSquare)
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

