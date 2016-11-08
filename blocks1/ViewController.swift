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
    
    //***********************************//
    /*Added Code*/
    
    
    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        for _ in 0..<25 {
        let rnd1 = Double.random(min: 0.1, max: 1.0)
        let rnd2 = Double.random(min: 0.1, max: 1.0)
        let rnd3 = Double.random(min: 0.1, max: 1.0)
        cell.myLabel.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor(red: CGFloat(rnd1), green: CGFloat(rnd2), blue: CGFloat(rnd3), alpha: CGFloat(1.0))
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        count += 1
        counterLabel.text = "\(count)"
        print("You selected cell #\(indexPath.item)!")
    }

    //***********************************//
    /*My Code*/
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!

    var seconds = 60 //Default timer sets to 60
    var timer = Timer()
    var blockColor = 0.0
    var count = 0
    
    @IBAction func playButtonPressed(_ sender: AnyObject) {
        setupGame()
        timerLabel.isHidden = false
    }
    
    func setupGame()  {
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    
        playButton.isHidden = true
        counterLabel.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
        counterLabel.isHidden = true
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
