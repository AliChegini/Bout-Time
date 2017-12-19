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
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    
    
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
        let vc = segue.destination as! DisplayScoreController
        vc.point = point
        vc.roundsPerGame = roundsPerGame
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
            timer.isHidden = true
            resultButton.isHidden = false
            resultButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
            playCorrectAnswerSound()
        } else {
            timer.isHidden = true
            resultButton.isHidden = false
            resultButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: .normal)
            playWrongAnswerSound()
        }
    }
    
    // Helper function to play again
    func playAgain() {
        currentRound = 1
        point = 0
        resetTimer()
        timer.isHidden = false
        resultButton.isHidden = true
    }
    
    @IBAction func nextRound() {
        if currentRound < roundsPerGame {
            resetTimer()
            displayEvents()
            currentRound += 1
        } else {
            // Load modal view for segue
            self.performSegue(withIdentifier: "scoreSegue" , sender: nil)
            playAgain()
        }
    }
    
    
    
    // In each move function labels along with tags - year - get reordered
    @IBAction func moveDownLabel1() {
        button1.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted)
        
        let tempText = label1.text
        let tempTag = label1.tag
        
        label1.text = label2.text
        label1.tag = label2.tag
        
        label2.text = tempText
        label2.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel2() {
        button2.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        
        let tempText = label2.text
        let tempTag = label2.tag
        
        label2.text = label1.text
        label2.tag = label1.tag
        
        label1.text = tempText
        label1.tag = tempTag
    }
    
   
    @IBAction func moveDownLabel2() {
        button3.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        
        let tempText = label2.text
        let tempTag = label2.tag
        
        label2.text = label3.text
        label2.tag = label3.tag
        
        label3.text = tempText
        label3.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel3() {
        button4.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        
        let tempText = label3.text
        let tempTag = label3.tag
        
        label3.text = label2.text
        label3.tag = label2.tag
        
        label2.text = tempText
        label2.tag = tempTag
    }
    
    
    @IBAction func moveDownLabel3() {
        button5.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        
        let tempText = label3.text
        let tempTag = label3.tag
        
        label3.text = label4.text
        label3.tag = label4.tag
        
        label4.text = tempText
        label4.tag = tempTag
    }
    
    
    @IBAction func moveUpLabel4() {
        button6.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted)
        
        let tempText = label4.text
        let tempTag = label4.tag
        
        label4.text = label3.text
        label4.tag = label3.tag
        
        label3.text = tempText
        label3.tag = tempTag
    }
    
   
    // Display events
    func displayEvents() {
        let organizedEvents = EventManager.dictionaryUnarchiver(fromDictionary: dictionary)
        let eventPack = EventPack.provideEventPack(organizedEvents)
        
        // Populating labels with text and tag
        label1.text = eventPack.event1.event
        label1.tag = eventPack.event1.year
        
        label2.text = eventPack.event2.event
        label2.tag = eventPack.event2.year
        
        label3.text = eventPack.event3.event
        label3.tag = eventPack.event3.year
        
        label4.text = eventPack.event4.event
        label4.tag = eventPack.event4.year
        
        timer.isHidden = false
        resultButton.isHidden = true
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
            // if countdown is 0 game is over and display score
            validateAnswer()
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

