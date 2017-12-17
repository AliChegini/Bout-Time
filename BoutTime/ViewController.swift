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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveDownLabel1() {
        button1.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted)
        let temp = label1.text
        label1.text = label2.text
        label2.text = temp
    }
    
    
    @IBAction func moveUpLabel2() {
        button2.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        let temp = label2.text
        label2.text = label1.text
        label1.text = temp
    }
    
   
    @IBAction func moveDownLabel2() {
        button3.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        let temp = label2.text
        label2.text = label3.text
        label3.text = temp
    }
    
    
    
    @IBAction func moveUpLabel3() {
        button4.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        let temp = label3.text
        label3.text = label2.text
        label2.text = temp
    }
    
    @IBAction func moveDownLabel3() {
        button5.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        let temp = label3.text
        label3.text = label4.text
        label4.text = temp
    }
    
    @IBAction func moveUpLabel4() {
        button6.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted)
        let temp = label4.text
        label4.text = label3.text
        label3.text = temp
    }
    
    
    
    // Display events
    func displayEvents() {
        
        let eventPack = EventPack.provideEventPack(organizedEvents)
        label1.text = eventPack.event1.event
        label2.text = eventPack.event2.event
        label3.text = eventPack.event3.event
        label4.text = eventPack.event4.event
    }
    
    
    

}

