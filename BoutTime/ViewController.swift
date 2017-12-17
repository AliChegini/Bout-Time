//
//  ViewController.swift
//  BoutTime
//
//  Created by Ehsan on 11/12/2017.
//  Copyright © 2017 Ali C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    
    var dictionary: [String: Any] = [:]
    var organizedEvents: [HistoricalEvent]
    
    
    // Loading the data from a plist file
    required init?(coder aDecoder: NSCoder) {
        do {
            dictionary = try PlistConvertor.dictionary(fromFile: "EventsList", ofType: "plist")
            organizedEvents = EventManager.dictionaryUnarchiver(fromDictionary: dictionary)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayEvents()
        self.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if (label1.tag >= label2.tag) && (label2.tag >= label3.tag) && (label3.tag >= label4.tag) {
                timer.isHidden = true
            } else {
                timer.isHidden = false
            }
            
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
    }
    
    
}

