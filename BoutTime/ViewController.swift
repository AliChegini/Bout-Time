//
//  ViewController.swift
//  BoutTime
//
//  Created by Ehsan on 11/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox


class ViewController: UIViewController {
    
    @IBOutlet weak var label1: UIButton!
    @IBOutlet weak var label2: UIButton!
    @IBOutlet weak var label3: UIButton!
    @IBOutlet weak var label4: UIButton!
    
    
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    // All  the buttons with arrows
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    
    var dictionary: [String: Any] = [:]
    var point: Int = 0
    var playTime: Int = 60
    var staticPlayTime: Int = 60
    var scheduledTimer = Timer()
    var roundsPerGame: Int = 6
    var currentRound: Int = 1
    var isAnswerValidated: Bool = false
    
    // Audio variables
    var incorrectBuzz: SystemSoundID = 0
    var correctDing: SystemSoundID = 1
    
    
    // Converting the data from a plist file into dictionary
    required init?(coder aDecoder: NSCoder) {
        do {
            dictionary = try PlistConvertor.dictionary(fromFile: "EventsList", ofType: "plist")
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayEvents()
        runTimer()
        loadSounds()
        self.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sending variables to another view via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scoreSegue" {
            let vc = segue.destination as! DisplayScoreController
            vc.point = point
            vc.roundsPerGame = roundsPerGame
            
            vc.goPlayAgain = {
                self.dismiss(animated: true, completion: nil)
                self.playAgain()
            }
        }
        
    }
    
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            validateAnswer()
        }
    }
    
    // Helper method to check the ordering
    func validateAnswer() {
        if (label1.tag >= label2.tag) && (label2.tag >= label3.tag) && (label3.tag >= label4.tag) {
            point += 1
            resultMode()
            disableButtons()
            playCorrectAnswerSound()
            resultButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
        } else {
            resultMode()
            disableButtons()
            playWrongAnswerSound()
            resultButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
        }
        
        isAnswerValidated = true
    }
    
    
    // Helper function to play again
    func playAgain() {
        print("playAgain() is called in main view")
        currentRound = 1
        point = 0
        resetTimer()
        isAnswerValidated = false
        displayEvents()
    }
    
    // functions to enable/disable all the buttons
    func disableButtons() {
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        button4.isEnabled = false
        button5.isEnabled = false
        button6.isEnabled = false
    }
    
    func enableButtons() {
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        button4.isEnabled = true
        button5.isEnabled = true
        button6.isEnabled = true
    }
    
   
    @IBAction func nextRound() {
        if currentRound < roundsPerGame {
            enableButtons()
            resetTimer()
            // reset the isAnswerValidated to initial state
            isAnswerValidated = false
            displayEvents()
            currentRound += 1
            print(currentRound)
        } else {
            // as answer is already checked in the last round, set it to true
            isAnswerValidated = true
            // Load modal view for segue
            self.performSegue(withIdentifier: "scoreSegue" , sender: nil)
        }
    }
    
    
    
    // In each move function labels along with tags - year - get reordered
    @IBAction func moveDownLabel1() {
        button1.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted)
        
        let tempText = label1.title(for: .normal)
        let tempTag = label1.tag
        
        label1.setTitle(label2.title(for: .normal), for: .normal)
        label1.tag = label2.tag
        
        label2.setTitle(tempText, for: .normal)
        label2.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel2() {
        button2.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        
        let tempText = label2.title(for: .normal)
        let tempTag = label2.tag
        
        label2.setTitle(label1.title(for: .normal), for: .normal)
        label2.tag = label1.tag
        
        label1.setTitle(tempText, for: .normal)
        label1.tag = tempTag
    }
    
   
    @IBAction func moveDownLabel2() {
        button3.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        
        let tempText = label2.title(for: .normal)
        let tempTag = label2.tag
        
        label2.setTitle(label3.title(for: .normal), for: .normal)
        label2.tag = label3.tag
        
        label3.setTitle(tempText, for: .normal)
        label3.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel3() {
        button4.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        
        let tempText = label3.title(for: .normal)
        let tempTag = label3.tag
        
        label3.setTitle(label2.title(for: .normal), for: .normal)
        label3.tag = label2.tag
        
        label2.setTitle(tempText, for: .normal)
        label2.tag = tempTag
    }
    
    
    @IBAction func moveDownLabel3() {
        button5.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        
        let tempText = label3.title(for: .normal)
        let tempTag = label3.tag
        
        label3.setTitle(label4.title(for: .normal), for: .normal)
        label3.tag = label4.tag
        
        label4.setTitle(tempText, for: .normal)
        label4.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel4() {
        button6.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted)
        
        let tempText = label4.title(for: .normal)
        let tempTag = label4.tag
        
        label4.setTitle(label3.title(for: .normal), for: .normal)
        label4.tag = label3.tag
        
        label3.setTitle(tempText, for: .normal)
        label3.tag = tempTag
    }
    
   
    // Display events
    func displayEvents() {
        let organizedEvents = EventManager.dictionaryUnarchiver(fromDictionary: dictionary)
        let eventPack = EventPack.provideEventPack(organizedEvents)
        
        // Populating labels with text and tag
        label1.setTitle(eventPack.event1.event, for: .normal)
        label1.tag = eventPack.event1.year
        
        label2.setTitle(eventPack.event2.event, for: .normal)
        label2.tag = eventPack.event2.year
        
        label3.setTitle(eventPack.event3.event, for: .normal)
        label3.tag = eventPack.event3.year
        
        label4.setTitle(eventPack.event4.event, for: .normal)
        label4.tag = eventPack.event4.year
        
        displayMode()
        enableButtons()
    }
    
    
    // Helper functions to show and hide timer and result button
    func displayMode() {
        timer.isHidden = false
        resultButton.isHidden = true
        disableWebView()
    }
    
    func resultMode() {
        timer.isHidden = true
        resultButton.isHidden = false
        enableWebView()
    }
    
    // functions to enable and disable the webView
    func disableWebView() {
        label1.isEnabled = false
        label2.isEnabled = false
        label3.isEnabled = false
        label4.isEnabled = false
    }
    
    func enableWebView() {
        label1.isEnabled = true
        label2.isEnabled = true
        label3.isEnabled = true
        label4.isEnabled = true
    }
    
    
    // The countdown timer for the game
    func runTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Showing the countdown on screen
    @objc func updateTimer() {
        if playTime > 0 {
            playTime -= 1
            timer.text = "\(playTime)"
        } else if playTime == 0 {
            if isAnswerValidated == false {
                validateAnswer()
            }
        }
    }
    
    func resetTimer() {
        playTime = staticPlayTime
        timer.text = "GO!"
    }
    
    
    // load and play sounds for correct and wrong answer
    func loadSounds() {
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "CorrectDing", ofType: "wav")
        let correctSoundURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(correctSoundURL as CFURL, &correctDing)
        
        let pathToWrongSoundFile = Bundle.main.path(forResource: "IncorrectBuzz", ofType: "wav")
        let wrongSoundURL = URL(fileURLWithPath: pathToWrongSoundFile!)
        AudioServicesCreateSystemSoundID(wrongSoundURL as CFURL, &incorrectBuzz)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(correctDing)
    }
    
    func playWrongAnswerSound() {
        AudioServicesPlaySystemSound(incorrectBuzz)
    }
    
    
}

