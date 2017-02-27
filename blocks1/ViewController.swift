//
//  ViewController.swift
//  blocks1
//
//  Created on 10/19/16.
//  Copyright © 2016 Scott Miller. All rights reserved.
//

//Notes

//Feb 26
//Snap to grid & reject move are conflicting

//Feb 25
//Added new code in "new code" tags. Also added a "validMatch" variable to my match check statement

//Feb 24
//Trophies/achievments (Under 30 moves, popup slides down on top

//Feb 22

//Movement
//Click Blocks label on top to pause (brings up a mid-game menu with a help and continue button.


import UIKit
import GameKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var counterLabel: UILabel!
    
    var colorsRed: [Double] = [1.0, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.9, /*8*/ 1.0, 1.0, 0.2, 0.6, 0.5, 0.8, 0.9, 0.6, 0.0, 0.9]
    var colorsGreen: [Double] = [0.1, 0.8, 0.3, 0.6, 0.7, 0.4, 0.1, 0.3, /*8*/ 1.0, 1.0, 0.6, 1.0, 0.5, 0.3, 0.2, 0.9, 0.5, 0.8]
    var colorsBlue: [Double] = [0.2, 0.3, 0.6, 0.9, 0.4, 0.5, 0.6, 0.5, /*8*/ 1.0, 1.0, 0.9, 0.1, 0.2, 0.3, 0.9, 0.4, 0.3, 0.2]
    var colorsAlpha: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, /*8*/ 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    var orderArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
    
    //Block and Circle arrays
    var myBlocks = [UIImageView]()
    var myCircles = [UIImageView]()
    
    var menuView = UIView()
    var menuLabel = UILabel()
    var menuPlay = UIButton()
    var menuProfile = UIButton()
    var menuHelp = UIButton()
    var timerLabel = UILabel()
    var gameTopTitle = UILabel()
    var gameTopCounter = UILabel()
    var outOfTimeLabel = UILabel()
    var allMatchesLabel = UILabel()
    var profileBackToMenu = UIButton()
    
    var vibrationSwitch = UISwitch()
    var musicSwitch = UISwitch()
    
    var player: AVAudioPlayer?
    var vibrationText = UILabel()
    var musicText = UILabel()
    var allowVibrations = true
    var allowMusic = true
    
    //Post game
    var postGameView = UIView()
    var postGamePlayButton = UIButton()
    
    var statsMatchesLabel = UILabel()
    var statsMovesLabel = UILabel()
    var statsTimeLabel = UILabel()
    var statsScoreLabel = UILabel()
    
    //counting
    var moveCounter = 0
    var arrayCounter = 0
    var circleLocation = 0
    var matchCounter = 0
    var score = 0
    
    //timing
    var seconds = 0
    var timer = Timer()
    var outOfTime = false
    
    //movement variables
    var objectDragging = 0
    var isDragging = false
    var initPosx = 0
    var initPosy = 0
    var validMove = false
    
    var movingUp = false
    var movingLeft = false
    var movingRight = false
    var movingDown = false
    
    //match checking
    var pos1 = CGPoint (x: 0.0, y: 0.0)
    var pos2 = CGPoint (x: 0.0, y: 0.0)
    
    var xMatchTag = 0
    var yMatchTag = 0
    var allMatches = false

    
    /** Menu **/
    
    func preGame() {
        
         for x in myCircles {
         x.removeFromSuperview()
         }
        
        //Reset counting variables
        arrayCounter = 0
        moveCounter = 0
        matchCounter = 0
        
        
        //Configure Labels
        timerLabel.isHidden = false
        statsMatchesLabel.isHidden = true
        statsMovesLabel.isHidden = true
        statsTimeLabel.isHidden = true
        statsScoreLabel.isHidden = true
        
        
        //Set view background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "PreBG.jpg")!)
        
        //Build the menu box
        menuView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 385))
        menuView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.view.addSubview(menuView)
        menuView.layer.zPosition = 1;
        //menuView.layer.cornerRadius = 10
        menuView.isHidden = false
        
        //Menu shadow
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 0.7
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = 15
        
        //Center the menu
        menuView.center = self.view.center
        menuView.center.x = self.view.center.x
        menuView.center.y = self.view.center.y
        
        //Menu label (Blocks title)
        menuLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        menuLabel.font = UIFont(name: "Lombok", size: 45.0)
        menuLabel.center = CGPoint(x: 160, y: 285)
        menuLabel.textAlignment = .center
        menuLabel.text = "Blocks"
        menuLabel.layer.zPosition = 1;
        menuLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(menuLabel)
        
        //Blocks title shadow
        menuLabel.layer.shadowColor = UIColor.black.cgColor
        menuLabel.layer.shadowOpacity = 0.7
        menuLabel.layer.shadowOffset = CGSize.zero
        menuLabel.layer.shadowRadius = 4
        
        menuLabel.center = self.view.center
        menuLabel.center.x = self.view.center.x
        menuLabel.center.y = self.view.center.y - 75
        
        //Menu play button
        menuPlay = UIButton(frame: CGRect(x: 25, y: 25, width: 270, height: 55))
        menuPlay.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 0.9)
        //menuPlay.titleLabel?.font = UIFont.init(name: "Helvetica", size:30)
        menuPlay.titleLabel!.font =  UIFont(name: "Helvetica", size: 40)
        menuPlay.setTitle("PLAY", for: .normal)
        menuPlay.addTarget(self, action:#selector(self.menuPlayButtonClicked), for: .touchUpInside)
        self.view.addSubview(menuPlay)
        menuPlay.layer.zPosition = 1;
        
        
        menuPlay.center = self.view.center
        menuPlay.center.x = self.view.center.x
        menuPlay.center.y = self.view.center.y + 45
        
        //Menu profile button
        menuProfile = UIButton(frame: CGRect(x: 25, y: 25, width: 270, height: 55))
        menuProfile.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 0.6)
        //menuPlay.titleLabel?.font = UIFont.init(name: "Helvetica", size:30)
        menuProfile.titleLabel!.font =  UIFont(name: "Helvetica", size: 40)
        menuProfile.setTitle("PROFILE", for: .normal)
        menuProfile.addTarget(self, action:#selector(self.menuProfileButtonClicked), for: .touchUpInside)
        self.view.addSubview(menuProfile)
        menuProfile.layer.zPosition = 1;
        
        menuProfile.center = self.view.center
        menuProfile.center.x = self.view.center.x
        menuProfile.center.y = self.view.center.y + 105
        
        //Menu help button
        menuHelp = UIButton(frame: CGRect(x: 25, y: 25, width: 270, height: 55))
        menuHelp.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 0.9)
        menuHelp.titleLabel!.font =  UIFont(name: "Helvetica", size: 40)
        menuHelp.setTitle("HELP", for: .normal)
        menuHelp.addTarget(self, action:#selector(self.menuHelpButtonClicked), for: .touchUpInside)
        self.view.addSubview(menuHelp)
        menuHelp.layer.zPosition = 1;
        
        
        menuHelp.center = self.view.center
        menuHelp.center.x = self.view.center.x
        menuHelp.center.y = self.view.center.y + 165
        
        //Game top title (middle)
        gameTopTitle = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        gameTopTitle.font = UIFont(name: "Lombok", size: 45)
        gameTopTitle.center = CGPoint(x: 160, y: 285)
        gameTopTitle.textAlignment = .center
        gameTopTitle.text = "Blocks"
        gameTopTitle.layer.zPosition = 1;
        gameTopTitle.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(gameTopTitle)
        gameTopTitle.isHidden = true
        
        gameTopTitle.center = self.view.center
        gameTopTitle.center.x = self.view.center.x
        gameTopTitle.center.y = self.view.center.y - 330
        
        //Vibration text
        vibrationText = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        vibrationText.font = UIFont(name: "Helvetica", size: 20)
        vibrationText.textAlignment = .center
        vibrationText.text = "Vibrations"
        self.view!.addSubview(vibrationText)
        vibrationText.layer.zPosition = 1
        vibrationText.center = self.view.center
        vibrationText.center.x = self.view.center.x - 35
        vibrationText.center.y = self.view.center.y - 111
        
        //Vibration switch
        vibrationSwitch = UISwitch(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        vibrationSwitch.isOn = true
        vibrationSwitch.setOn(true, animated: false)
        vibrationSwitch.addTarget(self, action: #selector(vibrationSwitchValueDidChange), for: .valueChanged)
        self.view!.addSubview(vibrationSwitch)
        vibrationSwitch.layer.zPosition = 1
        
        vibrationSwitch.center = self.view.center
        vibrationSwitch.center.x = self.view.center.x + 45
        vibrationSwitch.center.y = self.view.center.y - 110
        
        //Music text
        musicText = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        musicText.font = UIFont(name: "Helvetica", size: 20)
        musicText.textAlignment = .center
        musicText.text = "Music"
        self.view!.addSubview(musicText)
        musicText.layer.zPosition = 1
        
        musicText.center = self.view.center
        musicText.center.x = self.view.center.x - 17
        musicText.center.y = self.view.center.y - 156
        
        //Music switch
        musicSwitch = UISwitch(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        musicSwitch.isOn = true
        musicSwitch.setOn(true, animated: false)
        musicSwitch.addTarget(self, action: #selector(musicSwitchValueDidChange), for: .valueChanged)
        self.view!.addSubview(musicSwitch)
        musicSwitch.layer.zPosition = 1
        
        musicSwitch.center = self.view.center
        musicSwitch.center.x = self.view.center.x + 45
        musicSwitch.center.y = self.view.center.y - 155
        
        //Menu help button
        profileBackToMenu = UIButton(frame: CGRect(x: 25, y: 25, width: 270, height: 55))
        profileBackToMenu.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.8, alpha: 0.6)
        profileBackToMenu.titleLabel!.font =  UIFont(name: "Helvetica", size: 40)
        profileBackToMenu.setTitle("MENU", for: .normal)
        profileBackToMenu.addTarget(self, action:#selector(self.profileBackToMenuButtonClicked), for: .touchUpInside)
        self.view.addSubview(profileBackToMenu)
        profileBackToMenu.layer.zPosition = 1;
        
        
        profileBackToMenu.center = self.view.center
        profileBackToMenu.center.x = self.view.center.x
        profileBackToMenu.center.y = self.view.center.y + 165
        
        musicText.isHidden = true
        musicSwitch.isHidden = true
        vibrationText.isHidden = true
        vibrationSwitch.isHidden = true
        profileBackToMenu.isHidden = true
        
        let musicDefaults = UserDefaults.standard
        let vibrationDefaults = UserDefaults.standard
        
        if (musicDefaults.object(forKey: "MusicSwitchState") != nil) {
            musicSwitch.isOn = musicDefaults.bool(forKey: "MusicSwitchState")
        }
        if (vibrationDefaults.object(forKey: "VibrationSwitchState") != nil) {
            vibrationSwitch.isOn = vibrationDefaults.bool(forKey: "VibrationSwitchState")
        }
        
        print("In preGame")
    }

    func postGame(){
        print("In Post Game")
        timerLabel.removeFromSuperview()
        
        for x in myBlocks {
            x.removeFromSuperview()
        }
        
        initPosx = 0
        initPosy = 0
        
        score = (Int(Double(seconds) * (Double(matchCounter * 1)) + (Double(matchCounter) * ((Double(moveCounter)) * 0.1))))

        
        //Set view background
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "PostBG.jpg")!)
        
        gameTopTitle.isHidden = true
        gameTopCounter.isHidden = false
        
        timer.invalidate()
        
        //Build the menu box
        postGameView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 320))
        postGameView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.view.addSubview(postGameView)
        postGameView.layer.zPosition = 1;
        postGameView.isHidden = false
        
        //Menu shadow
        postGameView.layer.shadowColor = UIColor.black.cgColor
        postGameView.layer.shadowOpacity = 0.7
        postGameView.layer.shadowOffset = CGSize.zero
        postGameView.layer.shadowRadius = 12
        
        //Center the menu
        postGameView.center = self.view.center
        postGameView.center.x = self.view.center.x
        postGameView.center.y = self.view.center.y
        
        /*Blocks title
        menuLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 55))
        menuLabel.font = UIFont(name: "Lombok", size: 48)
        menuLabel.center = CGPoint(x: 160, y: 285)
        menuLabel.textAlignment = .center
        menuLabel.text = "Blocks"
        menuLabel.layer.zPosition = 1;
        menuLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(menuLabel)
        
        //Blocks title shadow
        menuLabel.layer.shadowColor = UIColor.black.cgColor
        menuLabel.layer.shadowOpacity = 0.7
        menuLabel.layer.shadowOffset = CGSize.zero
        menuLabel.layer.shadowRadius = 4
        
        menuLabel.center = self.view.center
        menuLabel.center.x = self.view.center.x
        menuLabel.center.y = self.view.center.y - 75*/
        
        if allMatches == true {
            allMatchesLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 65))
            allMatchesLabel.font = UIFont(name: "Helvetica", size: 30.0)
            allMatchesLabel.center = CGPoint(x: 160, y: 285)
            allMatchesLabel.textAlignment = .center
            allMatchesLabel.text = "You got them!"
            allMatchesLabel.layer.zPosition = 1;
            allMatchesLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            self.view.addSubview(allMatchesLabel)
            
            allMatchesLabel.layer.shadowColor = UIColor.black.cgColor
            allMatchesLabel.layer.shadowOpacity = 0.5
            allMatchesLabel.layer.shadowOffset = CGSize.zero
            allMatchesLabel.layer.shadowRadius = 3
            
            allMatchesLabel.center = self.view.center
            allMatchesLabel.center.x = self.view.center.x
            allMatchesLabel.center.y = self.view.center.y - 100
            allMatches = false
            allMatchesLabel.isHidden = false
        }
        
        //Out of time / All matches made
        else if outOfTime == true {
        outOfTimeLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 60))
        outOfTimeLabel.font = UIFont(name: "Helvetica", size: 30.0)
        outOfTimeLabel.center = CGPoint(x: 160, y: 285)
        outOfTimeLabel.textAlignment = .center
        outOfTimeLabel.text = "Out of time"
        outOfTimeLabel.layer.zPosition = 1;
        outOfTimeLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(outOfTimeLabel)
            
            outOfTimeLabel.layer.shadowColor = UIColor.black.cgColor
            outOfTimeLabel.layer.shadowOpacity = 0.5
            outOfTimeLabel.layer.shadowOffset = CGSize.zero
            outOfTimeLabel.layer.shadowRadius = 3
        
        outOfTimeLabel.center = self.view.center
        outOfTimeLabel.center.x = self.view.center.x
        outOfTimeLabel.center.y = self.view.center.y - 100
        outOfTime = false
        outOfTimeLabel.isHidden = false
        }
        
        //Stats (Time)
        statsTimeLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 60))
        statsTimeLabel.font = UIFont(name: "Helvetica", size: 20.0)
        statsTimeLabel.center = CGPoint(x: 160, y: 285)
        statsTimeLabel.textAlignment = .center
        statsTimeLabel.text = "Time left: \(seconds)"
        statsTimeLabel.layer.zPosition = 1;
        statsTimeLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(statsTimeLabel)
        
        statsTimeLabel.center = self.view.center
        statsTimeLabel.center.x = self.view.center.x //- 65
        statsTimeLabel.center.y = self.view.center.y - 35
        statsTimeLabel.isHidden = false
        
        
        //Stats (Matches)
        statsMatchesLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 60))
        statsMatchesLabel.font = UIFont(name: "Helvetica", size: 20.0)
        statsMatchesLabel.center = CGPoint(x: 160, y: 285)
        statsMatchesLabel.textAlignment = .center
        statsMatchesLabel.text = "Matches: \(matchCounter)"
        statsMatchesLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        statsMatchesLabel.layer.zPosition = 1;
        self.view.addSubview(statsMatchesLabel)
        
        statsMatchesLabel.center = self.view.center
        statsMatchesLabel.center.x = self.view.center.x //- 65
        statsMatchesLabel.center.y = self.view.center.y - 10
        statsMatchesLabel.isHidden = false
        
        
        //Stats (Moves)
        statsMovesLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 60))
        statsMovesLabel.font = UIFont(name: "Helvetica", size: 20.0)
        statsMovesLabel.center = CGPoint(x: 160, y: 285)
        statsMovesLabel.textAlignment = .center
        statsMovesLabel.text = "Moves: \(moveCounter)"
        statsMovesLabel.layer.zPosition = 1;
        statsMovesLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(statsMovesLabel)
        
        statsMovesLabel.center = self.view.center
        statsMovesLabel.center.x = self.view.center.x //+ 65
        statsMovesLabel.center.y = self.view.center.y + 15
        statsMovesLabel.isHidden = false
        
        
        //Stats (Score)
        statsScoreLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 270, height: 60))
        statsScoreLabel.font = UIFont(name: "Helvetica", size: 30.0)
        statsScoreLabel.center = CGPoint(x: 160, y: 285)
        statsScoreLabel.textAlignment = .center
        statsScoreLabel.text = "Score: \(score)"
        statsScoreLabel.layer.zPosition = 1;
        statsScoreLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(statsScoreLabel)
        
            statsScoreLabel.layer.shadowColor = UIColor.black.cgColor
            statsScoreLabel.layer.shadowOpacity = 0.6
            statsScoreLabel.layer.shadowOffset = CGSize.zero
            statsScoreLabel.layer.shadowRadius = 5
        
        statsScoreLabel.center = self.view.center
        statsScoreLabel.center.x = self.view.center.x //+ 60
        statsScoreLabel.center.y = self.view.center.y + 70
        statsScoreLabel.isHidden = false
        
        
        //Post game play button
        postGamePlayButton = UIButton(frame: CGRect(x: 25, y: 25, width: 270, height: 55))
        postGamePlayButton.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 0.9)
        postGamePlayButton.setTitle("Menu", for: .normal)
        postGamePlayButton.titleLabel!.font =  UIFont(name: "Helvetica", size: 40)
        postGamePlayButton.addTarget(self, action:#selector(self.postGamePlayButtonClicked), for: .touchUpInside)
        self.view.addSubview(postGamePlayButton)
        postGamePlayButton.layer.zPosition = 1;
        
        postGamePlayButton.center = self.view.center
        postGamePlayButton.center.x = self.view.center.x
        postGamePlayButton.center.y = self.view.center.y + 133
        

        
        gameTopCounter.removeFromSuperview()

        
    }
    func setupGame()  {
        
        print("In setupGame")
        
        if musicSwitch.isOn {
        playGameMusic()
        }
        
        myBlocks.removeAll()
        myCircles.removeAll()
        
        arrayCounter = 0
        matchCounter = 0
        moveCounter = 0
        seconds = 30
        
        gameTopCounter.isHidden = false
        outOfTimeLabel.isHidden = true
        allMatchesLabel.text = ""
        allMatchesLabel.isHidden = true
        vibrationSwitch.isHidden = true
        profileBackToMenu.isHidden = true
        menuProfile.isHidden = true
        
        
        //Timer label
        timerLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        timerLabel.font = UIFont(name: "Helvetica", size: 35.0)
        timerLabel.center = CGPoint(x: 160, y: 285)
        timerLabel.textAlignment = .center
        timerLabel.text = "\(seconds)"
        timerLabel.layer.zPosition = 1;
        timerLabel.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(timerLabel)
        
        timerLabel.center = self.view.center
        timerLabel.center.x = self.view.center.x - 150
        timerLabel.center.y = self.view.center.y - 334
        
        gameTopTitle.isHidden = false
        
        //Game top counter (right side)
        gameTopCounter = UILabel(frame: CGRect(x: 25, y: 25, width: 200, height: 50))
        gameTopCounter.font = UIFont(name: "Helvetica", size: 35)
        gameTopCounter.center = CGPoint(x: 160, y: 285)
        gameTopCounter.textAlignment = .center
        gameTopCounter.text = "\(moveCounter)"
        gameTopCounter.layer.zPosition = 1;
        gameTopCounter.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.view.addSubview(gameTopCounter)
        
        gameTopCounter.center = self.view.center
        gameTopCounter.center.x = self.view.center.x + 150
        gameTopCounter.center.y = self.view.center.y - 334
        
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
                myBlocks[arrayCounter].tag = arrayCounter
                
                squareImg.isUserInteractionEnabled = true
                
                squareImg.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:))))
                
                view.addSubview(squareImg)
                arrayCounter += 1
                squareImg.layer.zPosition = 2;
                nextPos += 1
            }
        }
        
        //Hide the two white squares built to index 8 and 9 (above the two white circles)
        myBlocks[8].removeFromSuperview()
        myBlocks[9].removeFromSuperview()
        myBlocks[8].isHidden = true
        myBlocks[9].isHidden = true
        
        //Call to set the tags for the circles and blocks on the screen
        //setTags()
        
        //******* Debugging ********//
        //Print out the index and tags, as well as tintColors
        for y in 0...17{
            print("index \(y)")
            print("BLOCK tag \(myBlocks[y].tag)")
            print("block color \(myBlocks[y].tintColor)")
            print("block center.x \(myBlocks[y].center.x)")
            print("block center.y \(myBlocks[y].center.y)")
            print("CIRCLE tag \(myCircles[y].tag)")
            print("circle color \(myCircles[y].tintColor)")
            print("")
        }
        
        /* Check here for initial game load matches? */
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.subtractTime), userInfo: nil, repeats: true)
    }

    
    func menuPlayButtonClicked() {
        print("Play Button Clicked")
        menuView.isHidden = true
        menuPlay.isHidden = true
        menuLabel.isHidden = true
        menuHelp.isHidden = true
        timerLabel.isHidden = false
        
        setupGame()
    }
    func menuProfileButtonClicked() {
        print("Play Button Clicked")
        menuProfile.isHidden = true
        vibrationSwitch.isHidden = false
        vibrationText.isHidden = false
        musicSwitch.isHidden = false
        musicText.isHidden = false
        menuPlay.isHidden = true
        menuLabel.isHidden = true
        menuHelp.isHidden = true
        profileBackToMenu.isHidden = false

    }
    func menuHelpButtonClicked() {
        print("Help Button Clicked")
        UIApplication.shared.openURL(NSURL(string: "http://scomiller.com/game")! as URL)
    }
    
    func profileBackToMenuButtonClicked(){
        musicText.isHidden = true
        musicSwitch.isHidden = true
        vibrationSwitch.isHidden = true
        vibrationText.isHidden = true
        menuLabel.isHidden = false
        menuPlay.isHidden = false
        menuProfile.isHidden = false
        menuHelp.isHidden = false
        profileBackToMenu.isHidden = true
        
    }
    func postGamePlayButtonClicked() {
        print("Post game play button clicked")
        timerLabel.removeFromSuperview()
        postGameView.isHidden = true
        postGamePlayButton.isHidden = true
        menuLabel.isHidden = true
        menuHelp.isHidden = true
        
        //seemed to have fixed the bug with the label lingering
        outOfTimeLabel.isHidden = true
        allMatchesLabel.isHidden = true
        
        preGame()
    }
    
    @IBAction func vibrationSwitchValueDidChange(sender: AnyObject) {
        let vibrationDefaults = UserDefaults.standard
        
        if vibrationSwitch.isOn {
            vibrationDefaults.set(true, forKey: "VibrationSwitchState")
            allowVibrations = true
        } else {
            vibrationDefaults.set(false, forKey: "VibrationSwitchState")
            allowVibrations = false
        }
    }
    
    @IBAction func musicSwitchValueDidChange(sender: AnyObject) {
        let musicDefaults = UserDefaults.standard
        
        if musicSwitch.isOn {
            musicDefaults.set(true, forKey: "MusicSwitchState")
            allowMusic = true
        } else {
            musicDefaults.set(false, forKey: "MusicSwitchState")
            allowMusic = false
            player?.stop()
        }
    }
    
    
    override func viewDidLoad() {
        preGame()
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
        pos2 = myCircles[circleLocation].center
        
        switch(recognizer.state) {
        case .began:
            
            initPosx = Int(recognizer.view!.center.x)
            initPosy = Int(recognizer.view!.center.y)

            
            let velocity = recognizer.velocity(in: self.view)
            print(velocity)
            
            movingUp = false
            movingLeft = false
            movingRight = false
            movingDown = false
            
            if velocity.x > 75 {
                movingRight = true
                myBlocks[objectDragging].center.y = CGFloat(initPosy)
            }
            else if velocity.x < -75 {
                movingLeft = true
                myBlocks[objectDragging].center.y = CGFloat(initPosy)
            }
            else if velocity.y < -30 {
                movingUp = true
                myBlocks[objectDragging].center.x = CGFloat(initPosx)
            }
            else {
                movingDown = true
                myBlocks[objectDragging].center.x = CGFloat(initPosx)
            }

            
        //New Code
        case .changed:
            
            
            if (movingRight == true) || (movingLeft == true)  {
                myBlocks[objectDragging].center.y = CGFloat(initPosy)
            }
            else if (movingDown == true) || (movingUp == true) {
                myBlocks[objectDragging].center.x = CGFloat(initPosx)
            }

        case .ended:
            
            movingUp = false
            movingLeft = false
            movingRight = false
            movingDown = false
    
            //Check to see if the move took place inside the bounds of the screen
            if (myBlocks[objectDragging].center.x <= 40 || myBlocks[objectDragging].center.x >= 360) {
                print("bounds clip")
                myBlocks[objectDragging].center.x = CGFloat(initPosx)
                myBlocks[objectDragging].center.y = CGFloat(initPosy)
            }
            else if (myBlocks[objectDragging].center.y <= 65 || myBlocks[objectDragging].center.y >= 720) {
                print("bounds clip")
                myBlocks[objectDragging].center.x = CGFloat(initPosx)
                myBlocks[objectDragging].center.y = CGFloat(initPosy)
            }
            
            //Check if block is in movement space
            for x in myBlocks {
            if (100 / 2 > sqrt((pos1.x - x.center.x) * (pos1.x - x.center.x) + (pos1.y - x.center.y) * (pos1.y - x.center.y))) {
                if ((x.tag != objectDragging) && (x.isHidden != true)) {
                    myBlocks[objectDragging].center.x = CGFloat(initPosx)
                    myBlocks[objectDragging].center.y = CGFloat(initPosy)
                    moveCounter -= 1
                    validMove = false
                    }
                else {
                    validMove = true
                    }
                }
            }
            
            //Set the block uniformly in the circle container
            for y in myCircles {
                if ((100 / 2 > sqrt((pos1.x - y.center.x) * (pos1.x - y.center.x) + (pos1.y - y.center.y) * (pos1.y - y.center.y))) && (validMove == true)){
                    myBlocks[objectDragging].center.x = y.center.x
                    myBlocks[objectDragging].center.y = y.center.y
                    if (CGFloat(initPosx) == myBlocks[objectDragging].center.x) && (CGFloat(initPosy) == myBlocks[objectDragging].center.y){
                        moveCounter -= 1
                        gameTopCounter.text = "\(moveCounter)"
                    }
                }
            }
            
            //Check match
            if ((100 / 2 > sqrt((pos1.x - pos2.x) * (pos1.x - pos2.x) + (pos1.y - pos2.y) * (pos1.y - pos2.y)) && (myBlocks[objectDragging].tintColor == myCircles[circleLocation].tintColor) && (validMove == true))) {
                
                myBlocks[objectDragging].isHidden = true
                myCircles[circleLocation].tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                if vibrationSwitch.isOn {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                matchCounter += 1
                
                if matchCounter == 16{
                allMatches = true
                allMatchesLabel.isHidden = false
                postGame()
                }
                else if seconds == 0{
                outOfTime = true
                postGame()
                }
            }
            else {
                moveCounter += 1
                gameTopCounter.text = "\(moveCounter)"
            }

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
            outOfTime = true
            postGame()
        }
        else if (seconds <= 10) {
            timerLabel.textColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func playGameMusic() {
        let diceRoll = Int(arc4random_uniform(3) + 1)
        var song = "null"
        
        switch diceRoll {
        case 1:
            song = "lilly"
        case 2:
            song = "launchTime"
        case 3:
            song = "brokenPlaces"
        default:
            break
        }
        
        let url = Bundle.main.url(forResource: (song), withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.volume = 0.2
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        print(diceRoll)
        print(song)
    }
}
